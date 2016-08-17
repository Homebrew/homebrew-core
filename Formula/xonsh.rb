class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.4.5.tar.gz"
  sha256 "1887206a62fab7ed24088f0d00cf549c4a69d6bfd638bde516a43e8102470a3b"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "a85d1a4414354de501d6889c0a4976126cd5ca0fcbddd352f87c5af0d075577e" => :el_capitan
    sha256 "fc01919f818b245adf1ffda020cb78abc538b307ba4b9ed7f8bc351bfebce84e" => :yosemite
    sha256 "a393e5202ea15888343b568d5d740a223221b6a909fb43f57c403e58e923e6c5" => :mavericks
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
