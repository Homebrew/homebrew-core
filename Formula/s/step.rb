class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.31.0/step_0.31.0.tar.gz"
  sha256 "28b8f239e4813566c68e92a7c00547dec0f3706da0c434e22a8048d012cb9246"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4d097e34ef3ec9bbac57af27566a201890679ac154c56555d7af217586bed4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ca195ed5744fb6faa55922309bb903beb84e72b4d244e580f5236042828b0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ed351d8139def7b42040b036068c48e6ced501ef714add5b46b238be882b190"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6148025e544caf2f24b4109ee620adc470503d3077f151648c4d389e2bfe10d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "69e67fd2d7de6c770711690685f46bd51c0d4fe41020a20f7ded624a15af0ba6"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.30.2/step-ca_0.30.2.tar.gz"
    sha256 "944b205d5ba89f393cbdc09d68ab7ce485f5b44f44c28025d30508af956c1cba"
  end

  # `test do` block runs a local step-ca server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    resource("certificates").stage do
      system "go", "mod", "download"
    end
  end

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?
    ldflags = %W[-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/step"
    generate_completions_from_executable(bin/"step", "completion")

    resource("certificates").stage do |r|
      ldflags = %W[-X main.Version=#{r.version} -X main.BuildTime=#{time.iso8601}]
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
