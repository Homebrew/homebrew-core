class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.2.tar.gz"
  sha256 "58bd878acdfe46372b56b3f4b764e85c1038bd149334731f778daa12ab072294"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "da5d3e32d9b9b940c0e7d6c8e7e8406d06fb8a5dd13bcdbfdb0b8059c056855c" => :sierra
    sha256 "25f8db5eb66b1482862c3c411a1f761f40c54c273578953bf274eaeea3384bf6" => :el_capitan
    sha256 "6218b185c3ffa22c1867f552b5b804faaef1c350f36523f68d20e77e055f88f9" => :yosemite
  end

  depends_on :python3

  resource "ply" do
    url "https://files.pythonhosted.org/packages/a8/4d/487e12d0478ee0cbb15d6fe9b8916e98fe4e2fce4cc65e4de309209c0b24/ply-3.9.tar.gz"
    sha256 "0d7e2940b9c57151392fceaa62b0865c45e06ce1e36687fd8d03f011a907f43e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
