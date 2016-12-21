class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.0.tar.gz"
  sha256 "171ce4824bc0109e2b1366cdc0bafa68d74285f4fa157d5f0c62a37d2a4d3972"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "55e35175ccc6592b2924e8690ebdcdf0d458974d3937538be09cc1a69500ba5d" => :sierra
    sha256 "a1938423beed03c26a9095ee3df1683bfabfd59a9f5fa46b4a29ae79a6e746f4" => :el_capitan
    sha256 "b7ef1558e95aa04bc5eca1cfd40768900f9c5ec250a9ca1db7f7f0adbfa78de1" => :yosemite
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
