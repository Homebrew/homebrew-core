class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.28.7/step_0.28.7.tar.gz"
  sha256 "64996b54975707ef0f3a9d0b8e8c32db8e3c954b7ad0d2f4ca82b050a37eaa8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "123883b473b0c45b43ef68a24e23540729d87e3d763228ce83f3080c48d6435d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a77c13dd1082b59f25a69f5809c678ceef54472ca25873d3356dceea6c0c7cd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b19beedb94544d19a8f33af15063befe6860613edec4f2fde1c88ae21a59af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57b8ec705af6c68e25acd09f8a4720a0e628a64de20d74a37468a9ec7e0a0730"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc7a9abb89069d0ccaeca7874bce8cf4ca08af087f4706f45e453f8436ecb70"
    sha256 cellar: :any_skip_relocation, ventura:       "070bede6372d8e470f06eb40258b4d99b1191baf46b81ac18a905c8cfeb24507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100eef27aab06162ed2745b3e6849ee1b3efc0f6fd071e2a401db550477df09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92b064d4aca479bc4241a00247c416e1e02faa4f8a0dd4b6c8d2523ab7f4170"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.28.2/step-ca_0.28.2.tar.gz"
    sha256 "9627f89ac96da1254d3f260c857a4544921ab59c52affc62034391f496a23876"
  end

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?
    ldflags = %W[-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/step"
    generate_completions_from_executable(bin/"step", "completion")

    resource("certificates").stage do |r|
      ldflags = %W[-s -w -X main.Version=#{r.version} -X main.BuildTime=#{time.iso8601}]
      system "go", "build", *std_go_args(ldflags:, output: bin/"step-ca"), "./cmd/step-ca"
    end
  end

  test do
    # Generate a public / private key pair. Creates foo.pub and foo.priv.
    system bin/"step", "crypto", "keypair", "foo.pub", "foo.priv", "--no-password", "--insecure"
    assert_path_exists testpath/"foo.pub"
    assert_path_exists testpath/"foo.priv"

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system bin/"step", "certificate", "create", "--profile", "root-ca",
        "--no-password", "--insecure", "baz", "baz.crt", "baz.key"
    assert_path_exists testpath/"baz.crt"
    assert_path_exists testpath/"baz.key"
    baz_crt = File.read(testpath/"baz.crt")
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, baz_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, baz_crt)
    baz_key = File.read(testpath/"baz.key")
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, baz_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, baz_key)
    shell_output("#{bin}/step certificate inspect --format json baz.crt > baz_crt.json")
    baz_crt_json = JSON.parse(File.read(testpath/"baz_crt.json"))
    assert_equal "CN=baz", baz_crt_json["subject_dn"]
    assert_equal "CN=baz", baz_crt_json["issuer_dn"]

    # Generate a leaf certificate signed by the previously created root.
    system bin/"step", "certificate", "create", "--profile", "intermediate-ca",
        "--no-password", "--insecure", "--ca", "baz.crt", "--ca-key", "baz.key",
        "zap", "zap.crt", "zap.key"
    assert_path_exists testpath/"zap.crt"
    assert_path_exists testpath/"zap.key"
    zap_crt = File.read(testpath/"zap.crt")
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, zap_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, zap_crt)
    zap_key = File.read(testpath/"zap.key")
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, zap_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, zap_key)
    shell_output("#{bin}/step certificate inspect --format json zap.crt > zap_crt.json")
    zap_crt_json = JSON.parse(File.read(testpath/"zap_crt.json"))
    assert_equal "CN=zap", zap_crt_json["subject_dn"]
    assert_equal "CN=baz", zap_crt_json["issuer_dn"]

    # Initialize a PKI and step-ca configuration, boot the CA, and create a
    # certificate using the API.
    (testpath/"password.txt").write("password")
    steppath = "#{testpath}/.step"
    mkdir_p(steppath)
    ENV["STEPPATH"] = steppath
    system bin/"step", "ca", "init", "--address", "127.0.0.1:8081",
        "--dns", "127.0.0.1", "--password-file", "#{testpath}/password.txt",
        "--provisioner-password-file", "#{testpath}/password.txt", "--name",
        "homebrew-smallstep-test", "--provisioner", "brew"

    begin
      pid = fork do
        exec bin/"step-ca", "--password-file", "#{testpath}/password.txt",
          "#{steppath}/config/ca.json"
      end

      sleep 6
      shell_output("#{bin}/step ca health > health_response.txt")
      assert_match(/^ok$/, File.read(testpath/"health_response.txt"))

      shell_output("#{bin}/step ca token --password-file #{testpath}/password.txt " \
                   "homebrew-smallstep-leaf > token.txt")
      token = File.read(testpath/"token.txt")
      system bin/"step", "ca", "certificate", "--token", token,
          "homebrew-smallstep-leaf", "brew.crt", "brew.key"

      assert_path_exists testpath/"brew.crt"
      assert_path_exists testpath/"brew.key"
      brew_crt = File.read(testpath/"brew.crt")
      assert_match(/^-----BEGIN CERTIFICATE-----.*/, brew_crt)
      assert_match(/.*-----END CERTIFICATE-----$/, brew_crt)
      brew_key = File.read(testpath/"brew.key")
      assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, brew_key)
      assert_match(/.*-----END EC PRIVATE KEY-----$/, brew_key)
      shell_output("#{bin}/step certificate inspect --format json brew.crt > brew_crt.json")
      brew_crt_json = JSON.parse(File.read(testpath/"brew_crt.json"))
      assert_equal "CN=homebrew-smallstep-leaf", brew_crt_json["subject_dn"]
      assert_equal "O=homebrew-smallstep-test, CN=homebrew-smallstep-test Intermediate CA", brew_crt_json["issuer_dn"]
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
