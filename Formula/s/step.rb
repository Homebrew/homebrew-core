class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.28.6/step_0.28.6.tar.gz"
  sha256 "1ab8ba1472e5dca30d863703c1b874541e5a1b5382ba9f2c26a00f652a75a2f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa444b239b3f7fbfd974fea34286d6e4f5721a8fe182fbf59a00dbdc378f55da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "044242cb1f678a5a2b1a9f8117f14fd27de2aa25da1b07c3ad76959c8b05ffb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "266aa8b378b9da8f379ac59b0839e2de1f1cdf0ca313115f1a781ebfb1282454"
    sha256 cellar: :any_skip_relocation, sonoma:        "bffab46cffe650a4df16627e862ed30f1f763c4c3edfe06a299501916bb14ecd"
    sha256 cellar: :any_skip_relocation, ventura:       "d70b34f83c66b289b062d2637a9a03ae116d76274d3bc1d8f6a9b477d0c1d353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8571a590547b33f37b8df1392608f2c55ba7fc2be0b6cb86d7508b14af044447"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.28.2/step-ca_0.28.2.tar.gz"
    sha256 "9627f89ac96da1254d3f260c857a4544921ab59c52affc62034391f496a23876"
  end

  def install
    ENV["VERSION"] = version.to_s
    ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
    system "make", "build"
    bin.install "bin/step" => "step"
    generate_completions_from_executable(bin/"step", "completion")

    resource("certificates").stage do |r|
      ENV["VERSION"] = r.version.to_s
      ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
      system "make", "build"
      bin.install "bin/step-ca" => "step-ca"
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
