class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.4.4/vault-cli-3.4.4-bin.tar.gz"
  sha256 "562e8b331936faa9e1735f48fe0da65cadf58c17638174211339cdee075cdf1c"
  head "https://github.com/apache/jackrabbit-filevault.git"

  bottle :unneeded

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system "#{bin}/vlt", "--version"
  end
end
