class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.1.26/vault-cli-3.1.26-bin.tar.gz"
  sha256 "21876ec9c61eec1b3f28a0e467a47856cc45604b203e6f181b15cf3440ff0616"

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
