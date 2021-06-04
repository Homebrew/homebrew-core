class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.6.2/zanata-cli-4.6.2-dist.tar.gz"
  sha256 "6d4bac8c5b908abf734ff23e0aca9b05f4bc13e66588c526448f241d90473132"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a46f0171f5febaf2693bb9a76f7a28fd221fc2a2213177d19b33af25dbe5a71"
  end

  depends_on arch: :x86_64
  depends_on "openjdk@8"

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
