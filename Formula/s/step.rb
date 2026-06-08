class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.30.2/step_0.30.2.tar.gz"
  sha256 "db62a88ebec709de591dd86eec9759e15bdff4c6b96f3d7db6f53b6cf86bd3ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4acf805409a5c6cbf25a89f13c6e412833299cc5dbd3887df689e03891fe2a48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508a217f15db5cb07ef40df9fa1dad35076a1f868883bdd0bc08e8139f4ced2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993500c4546a14b6735ee2cd26a50284d391928ac1dd41998cfaf631e509043a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07441dec92b33a6056968aa2282c42cb40687cb9bd8e6759f9fd77602a13567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f2ada4649549928a9ccd1200c0e0ffcd5b6e674fc84bd20f680f02714e643c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6252dbfa4e539db5e3172a6bf6fba2332842013d299698e91445bd0070c1b6f5"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.30.2/step-ca_0.30.2.tar.gz"
    sha256 "944b205d5ba89f393cbdc09d68ab7ce485f5b44f44c28025d30508af956c1cba"
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
