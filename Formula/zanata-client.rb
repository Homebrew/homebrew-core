class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/3.9.1/zanata-cli-3.9.1-dist.tar.gz"
  sha256 "ec59d9588308c22fa2070d902b8e53d205d4812ae38af1ea250eaad9d55f7863"

  bottle do
    cellar :any_skip_relocation
    sha256 "4813eecde6fe48ac41da9e068a64c1424fdfa7b418145c496a373a15167fcd93" => :sierra
    sha256 "4813eecde6fe48ac41da9e068a64c1424fdfa7b418145c496a373a15167fcd93" => :el_capitan
    sha256 "4813eecde6fe48ac41da9e068a64c1424fdfa7b418145c496a373a15167fcd93" => :yosemite
  end

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
