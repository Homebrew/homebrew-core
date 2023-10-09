class RichCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line toolbox for fancy output in the terminal"
  homepage "https://github.com/textualize/rich-cli"
  url "https://files.pythonhosted.org/packages/ca/55/e35962573948a148a4f63416d95d25fe75feb06d9ae2f9bb35adc416f894/rich-cli-1.8.0.tar.gz"
  sha256 "7f99ed213fb18c25999b644335f74d2be621a3a68593359e7fc62e95fe7e9a8a"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e31571f000cbf0d5688d0af6ef4e33f18f90aa18e0ec8680fca1d5cc93563794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c48b1acb9c3b4edb15a1af12135d1dbdfbd32f769b167965fe113d6eb14eb71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b74562fe26545db08cae77d9cc79843cb321b3f02a07d2c14798ae5bd868a6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "554771d511efa70f707d60390b4e7a2531d7c128639b7bd98646dcf84da677e2"
    sha256 cellar: :any_skip_relocation, ventura:        "0fc357b34eb0daf1d2ed1c7a28e6cdb2ea1208bc99d0d0b64918ff9bed6ed9b5"
    sha256 cellar: :any_skip_relocation, monterey:       "4a8e3e09bc1b314a462809e8966c3a4e74843e3c67217a86cdb9c8596d609446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eec52f301c7b50b8729f1c4c9fd00a4002a58e078bc79b25a530b9bc4277aaf1"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/7c/40/9e9dded097de3100713a0258793b2ddf8dd33cdb51c71b7ce8577cc2db4b/rich-rst-1.1.7.tar.gz"
    sha256 "898bd5defd6bde9fba819614575dc5bff18047af38ae1981de0c1e78f17bbfd5"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/8c/d1/c228993e8a21e24bb43a0376b2901b6f3f2033dae13e7f76d1103bb9b8a3/textual-0.1.18.tar.gz"
    sha256 "b2883f8ed291de58b9aa73de6d24bbaae0174687487458a4eb2a7c188a2acf23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/rich foo.md").strip
  end
end
