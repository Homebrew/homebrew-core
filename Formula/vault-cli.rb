class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.4.6/vault-cli-3.4.6-bin.tar.gz"
  sha256 "0a5a6fcb0dd40abe716dada3d86f1123b780e62324a9452af6718b1c989a3325"
  license "Apache-2.0"
  head "https://github.com/apache/jackrabbit-filevault.git"

  livecheck do
    url "https://repo1.maven.org/maven2/org/apache/jackrabbit/vault/vault-cli/"
    regex(%r{href=.*?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system "#{bin}/vlt", "--version"
  end
end
