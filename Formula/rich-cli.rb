class RichCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line toolbox for fancy output in the terminal"
  homepage "https://github.com/textualize/rich-cli"
  url "https://files.pythonhosted.org/packages/1f/72/a7b7536dc3e5d9d3f6eb02bf2107907a8bc916037b2f91a387fa4c907f55/rich-cli-1.7.0.tar.gz"
  sha256 "7e9a2bca579cf47fbd1b6bfc0f43b7d9e93b390b376114a66b5c4ea5a90296a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf30d7bc6ef19752b2c445957844732565c1c237625958b89fc0bb4e63125c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb53537c924cad2c597de273a82c1b992231f7b4928554214117a97f28f089c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a508a03685e3e32cc17169cf71d0ac10d12c9a13f6898e61d5d054ebf1b1ab68"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf8a0fe57aefeea9c70504c5bbf59b132f1211073f98929606d45a282545b4c4"
    sha256 cellar: :any_skip_relocation, catalina:       "762e444e082923f7b5420b08b7fcc25a13dbd48bdc2a18f3b336e77deb00f5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f71b1f94cc92cdac340521af9851983464284573a44aabaf41ffd6b857285e1"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a4/50/8e34f3f18dc3914bd14a0722cb471410488495fdcd93e122724d4dd8c5f9/rich-12.3.0.tar.gz"
    sha256 "7e8700cda776337036a712ff0495b04052fb5f957c7dfb8df997f88350044b64"
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
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/rich foo.md").strip
  end
end
