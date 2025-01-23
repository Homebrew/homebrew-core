class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.28.2/step_0.28.2.tar.gz"
  sha256 "f879ac21a9c7f8e943bbe8447aee42943877bd85b413eb3275a63e10ded08407"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6c51186b67ff0656225d8202c403766011c64390101f62fdc0ddd54e7b2de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30bab0a0ffacad99e6c66b88e2ca90067603f895ae26d235f2476a8254f1d655"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a4bcbac9b07a17473f15dfd4129af71ee5017ee5dc96b828d236fcc19bb2f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca1b5a970c77ff9fce1e584c571e82b20cff997fe8f385461e2b9d38b9b20557"
    sha256 cellar: :any_skip_relocation, ventura:       "ab3af98fdbb1d2e0a7408067c59c174aefec80e041743522d9eac16a81d2176d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f975006f1212fd25001974dc5d9de20ec9f9aac7f1de232d141b55026af8724d"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.28.1/step-ca_0.28.1.tar.gz"
    sha256 "932f4eac08071f1290da62834b0d665839c7b31b87f168d747fead42a6984d30"
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
    assert_predicate testpath/"foo.pub", :exist?
    assert_predicate testpath/"foo.priv", :exist?

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system bin/"step", "certificate", "create", "--profile", "root-ca",
        "--no-password", "--insecure", "baz", "baz.crt", "baz.key"
    assert_predicate testpath/"baz.crt", :exist?
    assert_predicate testpath/"baz.key", :exist?
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
    assert_predicate testpath/"zap.crt", :exist?
    assert_predicate testpath/"zap.key", :exist?
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

      assert_predicate testpath/"brew.crt", :exist?
      assert_predicate testpath/"brew.key", :exist?
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
