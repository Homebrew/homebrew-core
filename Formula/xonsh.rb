class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.4.7.tar.gz"
  sha256 "10732db7a635b94454232f389f1960a27736e63bb3ce7daf6dc59fda7d5f5abb"
  head "https://github.com/scopatz/xonsh.git"
  revision 1

  bottle do
    sha256 "a34d75dadf69aecf089f0cd7da0d512e720dea21852b2b4897b9a22d5d07dcb6" => :sierra
    sha256 "474da913366ca868e82f68358814732b5501aae2b535f70094fd531043455689" => :el_capitan
    sha256 "7a79e9a174da863de115181872762ddb56d650cee85d750c1bb1e343cd82d5ee" => :yosemite
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/96/e0/430fcdb6b3ef1ae534d231397bee7e9304be14a47a267e82ebcb3323d0b5/ply-3.8.tar.gz"
    sha256 "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
