class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.0.tar.gz"
  sha256 "171ce4824bc0109e2b1366cdc0bafa68d74285f4fa157d5f0c62a37d2a4d3972"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "a34d75dadf69aecf089f0cd7da0d512e720dea21852b2b4897b9a22d5d07dcb6" => :sierra
    sha256 "474da913366ca868e82f68358814732b5501aae2b535f70094fd531043455689" => :el_capitan
    sha256 "7a79e9a174da863de115181872762ddb56d650cee85d750c1bb1e343cd82d5ee" => :yosemite
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
