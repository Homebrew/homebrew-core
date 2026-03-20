class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.30.1/step_0.30.1.tar.gz"
  sha256 "0766a6f772de64245d5ffb03759b8902c6190fd335670cfdb543e65c6a795d4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3613d856bb4c07911a760c834e64b7ff24a9aeb881d1898a0ab944f370a5ca62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea914a7bfd7605649f519e6117db0a09d7149b113d4343509703ecff071634b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc73b04d3e6b455482705f95b6e1484814d8d534cfdcbc55d046fa1f3496732"
    sha256 cellar: :any_skip_relocation, sonoma:        "50a87d9707bea463ac1b19a7264b26870011d23ead263eb2bb403cdfb7fbe45d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad03f4350f38b66bd55d487b5f9cebef9d67bd64fa44579fc28e24117512261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9168630a6528372b2c11c967cc9ceb139386a5adbe13ef41b72936fab94a374"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.30.1/step-ca_0.30.1.tar.gz"
    sha256 "5dbe5ee400d7344156d5dde1da144f5224ba133765f52862797a0ef35bb734cc"
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
           "--dns", "127.0.0.1", "--password-file", testpath/"password.txt",
           "--provisioner-password-file", testpath/"password.txt", "--name",
           "homebrew-smallstep-test", "--provisioner", "brew"

    pid = spawn bin/"step-ca", "--password-file", testpath/"password.txt", "#{steppath}/config/ca.json"
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
