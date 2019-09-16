class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.4.0/vault-cli-3.4.0-bin.tar.gz"
  sha256 "e500ff02a95461a07442c817c8a975ca7294848f694dfc1c015011c19613f64d"
  head "https://github.com/apache/jackrabbit-filevault.git"

  bottle :unneeded

  depends_on :java

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system "#{bin}/vlt", "--version"
  end
end
