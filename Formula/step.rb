class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.23.0/step_0.23.0.tar.gz"
  sha256 "8056deefa22a2d5f5d60ceaf652346a3eb8e4ac2ccad535364b29de5e1830b4c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2376d94d5422780ee76a67f826b0877ca3afd119177aed3b1bce9bec5d054ef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9dce3736d1e84d91b450431f40a12a5ec0b8d1a59ad6992cc860dacb8132653"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28cd0adc2850d548a57e63bb90a6c1bd6b6c1e9bdc2772bd359b9641c200ea96"
    sha256 cellar: :any_skip_relocation, ventura:        "d22b28c4e15dac838e353e6da178657d104051100517bd15b594cfcbb58d2895"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e404eea2a8271ec05e2fff69f9d2ba772aeb5385ed7007f726080e289c4505"
    sha256 cellar: :any_skip_relocation, big_sur:        "eddef193e03941ea9c0f97a198bb0730e096cdd355dea7f57e08575dcf4efc8f"
    sha256 cellar: :any_skip_relocation, catalina:       "0186e7866573162f19822bb33cb3d2c14f77acf6236749fe2abbde2c2933324e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4def9aa0741bcf15c523b00628a6fcc7dbfed819fcf2c0834dc5c9cc5ac13397"
  end

  depends_on "go" => :build

  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.23.0/step-ca_0.23.0.tar.gz"
    sha256 "fc727c35d5513e9b6eebd4d5c183944af165b3dbdf3a788fa6d122cb2f3fc676"
  end

  def install
    ENV["VERSION"] = version.to_s
    ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
    system "make", "build"
    bin.install "bin/step" => "step"
    bash_completion.install "autocomplete/bash_autocomplete" => "step"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_step"

    resource("certificates").stage do |r|
      ENV["VERSION"] = r.version.to_s
      ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
      system "make", "build"
      bin.install "bin/step-ca" => "step-ca"
    end
  end

  test do
    # Generate a public / private key pair. Creates foo.pub and foo.priv.
    system "#{bin}/step", "crypto", "keypair", "foo.pub", "foo.priv", "--no-password", "--insecure"
    assert_predicate testpath/"foo.pub", :exist?
    assert_predicate testpath/"foo.priv", :exist?

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system "#{bin}/step", "certificate", "create", "--profile", "root-ca",
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
    system "#{bin}/step", "certificate", "create", "--profile", "intermediate-ca",
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
    system "#{bin}/step", "ca", "init", "--address", "127.0.0.1:8081",
        "--dns", "127.0.0.1", "--password-file", "#{testpath}/password.txt",
        "--provisioner-password-file", "#{testpath}/password.txt", "--name",
        "homebrew-smallstep-test", "--provisioner", "brew"

    begin
      pid = fork do
        exec "#{bin}/step-ca", "--password-file", "#{testpath}/password.txt",
          "#{steppath}/config/ca.json"
      end

      sleep 2
      shell_output("#{bin}/step ca health > health_response.txt")
      assert_match(/^ok$/, File.read(testpath/"health_response.txt"))

      shell_output("#{bin}/step ca token --password-file #{testpath}/password.txt " \
                   "homebrew-smallstep-leaf > token.txt")
      token = File.read(testpath/"token.txt")
      system "#{bin}/step", "ca", "certificate", "--token", token,
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
