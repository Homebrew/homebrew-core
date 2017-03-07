class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "tarsnap wrapper which expires backups using a gfs-scheme."
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://github.com/miracle2k/tarsnapper/archive/0.4.tar.gz"
  sha256 "94ac22c3ed72e6321596f7d229b34fd21b59a00035162c5b22f2a1ee64dc6d01"

  bottle do
    cellar :any_skip_relocation
    sha256 "0aa2373f1ef50e24b74933296bf8a4eb308e63eed566acad8eebeab2d52167b4" => :sierra
    sha256 "2fa8e6ec3c4b70e811777f514dd5b4e520a7736e61980b272828be0106f40ec5" => :el_capitan
    sha256 "5e9efabb3c91e9b6e39f10b1a421ad41bf74399c224094f085fcefbe23223a93" => :yosemite
  end

  depends_on "tarsnap"

  resource "argparse" do
    url "https://pypi.python.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "pexpect" do
    url "https://pypi.python.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "ptyprocess" do
    url "https://pypi.python.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match /usage: tarsnapper/, shell_output("#{bin}/tarsnapper --help")
  end
end
