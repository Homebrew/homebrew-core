class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.29.0/step_0.29.0.tar.gz"
  sha256 "231e857c0d008b8445b0d7026fc29459f2ef66fb3258760fb23a27de9562d4fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01da5647995127822d8dae5c5fecca39b2d8271b9c00a61bc6bd7a6af068b38e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bcbcc7fc607ac26a442b430fa4fca71849dd2afa32cb663a3d62a17e12575e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b10ac7ee90825cbceb2364aaf3063a90c4a5c69a867239db2b9a37ab4afd9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b6e856f77b53c3aab8b60b105e19eccb30cd634035dc4c0fe8ae7bbf1924c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab47cb83f0d77ad75196a4df9bc6bf49d56dc7e154596592c4ecd8ff01092ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0562a6d6d0f1da43ffad332117a3f67f207e41f4009fe57bd3b85244ae83339"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.29.0/step-ca_0.29.0.tar.gz"
    sha256 "b26641db2e8a63432f764c176db845eb98104bfd206a76ec6f574735744bcbc1"
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
    baz_crt = (testpath/"baz.crt").read
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, baz_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, baz_crt)
    baz_key = (testpath/"baz.key").read
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, baz_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, baz_key)
    baz_crt_json = JSON.parse(shell_output("#{bin}/step certificate inspect --format json baz.crt"))
    assert_equal "CN=baz", baz_crt_json["subject_dn"]
    assert_equal "CN=baz", baz_crt_json["issuer_dn"]

    # Generate a leaf certificate signed by the previously created root.
    system bin/"step", "certificate", "create", "--profile", "intermediate-ca",
           "--no-password", "--insecure", "--ca", "baz.crt", "--ca-key", "baz.key",
           "zap", "zap.crt", "zap.key"
    assert_path_exists testpath/"zap.crt"
    assert_path_exists testpath/"zap.key"
    zap_crt = (testpath/"zap.crt").read
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, zap_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, zap_crt)
    zap_key = (testpath/"zap.key").read
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, zap_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, zap_key)
    zap_crt_json = JSON.parse(shell_output("#{bin}/step certificate inspect --format json zap.crt"))
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

    pid = spawn bin/"step-ca", "--password-file", "#{testpath}/password.txt", "#{steppath}/config/ca.json"
    begin
      sleep 6
      assert_match(/^ok$/, shell_output("#{bin}/step ca health"))

      token = shell_output("#{bin}/step ca token --password-file #{testpath}/password.txt homebrew-smallstep-leaf")
      system bin/"step", "ca", "certificate", "--token", token, "homebrew-smallstep-leaf", "brew.crt", "brew.key"

      assert_path_exists testpath/"brew.crt"
      assert_path_exists testpath/"brew.key"
      brew_crt = (testpath/"brew.crt").read
      assert_match(/^-----BEGIN CERTIFICATE-----.*/, brew_crt)
      assert_match(/.*-----END CERTIFICATE-----$/, brew_crt)
      brew_key = (testpath/"brew.key").read
      assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, brew_key)
      assert_match(/.*-----END EC PRIVATE KEY-----$/, brew_key)
      brew_crt_json = JSON.parse(shell_output("#{bin}/step certificate inspect --format json brew.crt"))
      assert_equal "CN=homebrew-smallstep-leaf", brew_crt_json["subject_dn"]
      assert_equal "O=homebrew-smallstep-test, CN=homebrew-smallstep-test Intermediate CA", brew_crt_json["issuer_dn"]
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
