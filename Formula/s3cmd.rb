class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/65/6c/f51ba2fbc74916f4fe3883228450306135e13be6dcca03a08d3e91239992/s3cmd-2.2.0.tar.gz"
  sha256 "2a7d2afe09ce5aa9f2ce925b68c6e0c1903dd8d4e4a591cd7047da8e983a99c3"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966fb2bb8c02052b00b154326d9ccdd2f3ee5b342e2f044acb892c766ff687b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a8f7ba9cc505a9f85b520567fa4171b83b7d6c1629d54a4e4f28abb2beda118"
    sha256 cellar: :any_skip_relocation, monterey:       "28c1ceda3886f9e5ae34970e4688de15dddb88c79e1578664da5d7c98e22a034"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2c9c367aabe397103301708f12a3e3720fdf44ef73e46580a36cce82d89e59b"
    sha256 cellar: :any_skip_relocation, catalina:       "b4da753aa2c650ece82199208d9be19d87017adedcd686176fc412c539f1da6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddea25a32f3d8eb2ca957676a975b52b30990709c7ed880eccb797bb1e25bc58"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/3a/70/76b185393fecf78f81c12f9dc7b1df814df785f6acb545fc92b016e75a7e/python-magic-0.4.24.tar.gz"
    sha256 "de800df9fb50f8ec5974761054a708af6e4246b03b4bdaee993f948947b0ebcf"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
