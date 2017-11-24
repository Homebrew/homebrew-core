class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.3.2/zanata-cli-4.3.2-dist.tar.gz"
  sha256 "e8531cd220a2964c4ba181341eb1e1677674de7be9db73880458714ea8e7afad"

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
