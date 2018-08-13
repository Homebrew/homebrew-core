class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.6.1/zanata-cli-4.6.1-dist.tar.gz"
  sha256 "52e5ea67419e01991346ed25346e20f2740f80964bc829e6bffa828833772858"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.8+")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    output = shell_output("#{bin}/zanata-cli --help")
    assert_match "Zanata Java command-line client", output
  end
end
