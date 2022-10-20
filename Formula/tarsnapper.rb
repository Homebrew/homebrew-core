class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05cd1a4e633b9fc3151065bcb2a9c95adb5556b7dcca54f3cc17f9ede6419760"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "029b019760fd47798a534fdb372422c2c4b27aa37813b3967ab6674dea3ec4a8"
    sha256 cellar: :any_skip_relocation, monterey:       "c482cd0c68e786e20daec63b863837c78f246bf1e26a5703163efce02627bdc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "657387ce0238e63fa455564b2e2819f499eef2ed60afc714bb6aa5968a55313f"
    sha256 cellar: :any_skip_relocation, catalina:       "7aae07361f9c72e9503ea751758c36d17eacea8c0898ef4e3c0fac25df3ce7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b853fe15f274370797cfd81377c759cb844cedf91205b0b19850de3268a35b50"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "tarsnap"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}/tarsnapper --help")
  end
end
