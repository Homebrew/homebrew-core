class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.4.7.tar.gz"
  sha256 "10732db7a635b94454232f389f1960a27736e63bb3ce7daf6dc59fda7d5f5abb"
  head "https://github.com/scopatz/xonsh.git"
  revision 1

  bottle do
    sha256 "ccac8226487e90922c8bf699efeabeaf26a9ceef16c8657ce0f2ec6bf2af5987" => :sierra
    sha256 "a878e9870529f5c041615b8fb5936aae8c3571445bd21f0add9a7bb38830b202" => :el_capitan
    sha256 "3b75a585f4e26baf0b40d4789a7ad28bab12b18837f486b716c24de1ac2f8dc1" => :yosemite
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
