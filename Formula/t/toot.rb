class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.bezdomni.net/"
  url "https://files.pythonhosted.org/packages/e4/01/dcfb2d4fd58a5c96d99d9ff98f7a48cf0813e4a615b5953da11e67374075/toot-0.43.0.tar.gz"
  sha256 "6aa84c4b8df6e2214a3e735142bf5bd57b3b10aa08e35579425c5dbe3bc25ae7"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c411478bafca733b600dcf9ebcd94fdafa2aabb74b467b37fac77be30d141b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcfd36efcabfcc9e02255f96a422c67fe962bf018f9bb42b52225cf2a73abffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dca359111a5a00eaf563a086bc163c32957b010fb8844079e20d71ff6e124f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc0c2a2670e69bbccc46dd677b72c29f061fc83c926ea8bcb1579eec604428ad"
    sha256 cellar: :any_skip_relocation, ventura:        "1e28529a5851bd40fcdc18f7809f26fc8e5cb4ab9d6107cc8e9230fef48f048d"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa0fe1d49d080a7abe158315b431a37a7f41530bdf1136c2f89fa13181a0889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "245ab5de22d6152cfbd699070321ffdfeaab69aedb1cdf7cfb3db1e05f3dbda1"
  end

  depends_on "certifi"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "term-image" do
    url "https://files.pythonhosted.org/packages/f2/59/019a0ca982be3e6d686b9c58a72ae26333b69f8a312ea6edcbefef57279b/term-image-0.7.0.tar.gz"
    sha256 "d62d85b62b58a90576b2dc22478aeee7eb71bfac169862a0abc94c9f494c8b0c"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/2b/ab/18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8/tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/9e/e0/afd5f41a87cba266418622dc6e37fd18f61378aa56d73ea9ee01db3ceadd/urwid-2.6.12.tar.gz"
    sha256 "1c9f5a5b47ec3fcc88032e0e224a00d7bf21704fa0060f498db395235f1731f1"
  end

  resource "urwidgets" do
    url "https://files.pythonhosted.org/packages/16/1f/cb6f188ddd62a52b3fa5694c2a541309d246dee54e6d4bc7a4079b2bbc59/urwidgets-0.1.1.tar.gz"
    sha256 "1e0dbceb875ace11067d93a585d8842a011db14ce78ec69ed485dc0df17f09e7"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toot --version")
    assert_equal "You are not logged in to any accounts", shell_output("#{bin}/toot auth").chomp
  end
end
