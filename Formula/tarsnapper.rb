class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ac8f71359974b87ec296543400b6feed59990d637bb39bd76693f532901a9ba1"
    sha256 cellar: :any,                 arm64_big_sur:  "fb9e4083414f5e3c529a444047e4a840fbe008d8e1210ca35183c95e284712c5"
    sha256 cellar: :any,                 monterey:       "30725e21171a6c3151f778e5c710ce155aba69a5778610596df6b3b6fe6b944f"
    sha256 cellar: :any,                 big_sur:        "766dad885fa778bda3d99c853e14d4e3d179b9a1c11131165c4dd7875553d29f"
    sha256 cellar: :any,                 catalina:       "4e95af80521f93738700549a1683cf9a73c776d637587c065e7c0fa56985168e"
    sha256 cellar: :any,                 mojave:         "09e4372f39f9cb0d141ebc4d89835ebb6787baa3c0a20e6b791a919168035428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9c0304d01b9274fcd7acb0a8cb66610cac32f1c3aaf7e0b05b36c7ddd1b384"
  end

  depends_on "libyaml"
  depends_on "python@3.10"
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

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}/tarsnapper --help")
  end
end
