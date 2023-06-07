class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8690c0a428a6aec75099a4074a09fec690b075b637faf4516e31689ba0895997"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "115d72f69bbae2c7d0bcb2a6fd29c6a81b4d4c396f323291260de87ec994ed69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68cd9c18598e426c1543864175e1750c79b3226cba74dc2407c8458bbb1f38ec"
    sha256 cellar: :any_skip_relocation, ventura:        "491055fc9954b048f053a207620e530ccf0c9f6316165be99c68304d04276c22"
    sha256 cellar: :any_skip_relocation, monterey:       "132423d27552e162f1559a74619216f82989b45ba6180023eab2f819de89e3cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1b48f1909e44f5c9e80320b4c3f3b8a73393c23aab7e6a37d35a33ff403b04d"
    sha256 cellar: :any_skip_relocation, catalina:       "2e8d49bfaef413323218d6ef7f49e55d360d554c29abcd4e64a1b3c20198955a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f08e3a8c30c95c7242dd60019f249fc5de32e1b4483d403976c986d06632b4de"
  end

  depends_on "python@3.11"
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
