class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.4.4/zanata-cli-4.4.4-dist.tar.gz"
  sha256 "866bb3e3bb3a9ac309371e08e5019b75cf6b5235f14d87e0d648c140f039c634"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.8+")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    assert_match /Zanata Java command-line client/, shell_output("#{bin}/zanata-cli --help")
  end
end
