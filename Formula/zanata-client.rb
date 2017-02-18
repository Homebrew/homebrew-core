class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.1.0/zanata-cli-4.1.0-dist.tar.gz"
  sha256 "ac08f3da73bfa439b17389537d4ccc383fa4932f1b90fe456f7c671bf99ce7a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "028df1b1361d2b0f7296047ac0723bdce1a916dd10e1e98f33329ca5b8ff0466" => :sierra
    sha256 "028df1b1361d2b0f7296047ac0723bdce1a916dd10e1e98f33329ca5b8ff0466" => :el_capitan
    sha256 "028df1b1361d2b0f7296047ac0723bdce1a916dd10e1e98f33329ca5b8ff0466" => :yosemite
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
