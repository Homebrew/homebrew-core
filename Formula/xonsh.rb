class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.4.7.tar.gz"
  sha256 "10732db7a635b94454232f389f1960a27736e63bb3ce7daf6dc59fda7d5f5abb"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "6ff59185c363be4f9f635a65a98f5a968ef4f9dfd687566daa3606e04386e92a" => :sierra
    sha256 "eece97a51a30ca396a0371c5d6c87de204fb9fe4756242f501f0b5c760b017bd" => :el_capitan
    sha256 "71d81c66fef44644450ed2191c96fe6a12f0fdbf97a5168336404e247fb1caa7" => :yosemite
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
