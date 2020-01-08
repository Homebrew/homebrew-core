class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.6.2/zanata-cli-4.6.2-dist.tar.gz"
  sha256 "6d4bac8c5b908abf734ff23e0aca9b05f4bc13e66588c526448f241d90473132"
  revision 1

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.8")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    output = shell_output("#{bin}/zanata-cli --help")
    assert_match "Zanata Java command-line client", output
  end
end
