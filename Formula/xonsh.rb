class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.2.tar.gz"
  sha256 "58bd878acdfe46372b56b3f4b764e85c1038bd149334731f778daa12ab072294"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "14b2a4cb0c1becc0afe38f4d8e727f45d68a4ae03baa90f7ab8611cb8e812fcc" => :sierra
    sha256 "23cebc1083fc63468d502ed037d4d042478c881096268e5930c731da5a832a76" => :el_capitan
    sha256 "006966dad3dda716cc529ef4883bbb4bcd5b8f67ee9043341db28248038fb123" => :yosemite
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
