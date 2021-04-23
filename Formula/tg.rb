class Tg < Formula
  include Language::Python::Virtualenv

  desc "Terminal telegram client"
  homepage "https://github.com/paul-nameless/tg"
  url "https://github.com/paul-nameless/tg/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "2303983af7b7246fb3198bcae688d3b6327a96bbfc91c94ef9bc783cc7191f42"
  license "Unlicense"

  bottle :unneeded

  depends_on "python@3.9"
  depends_on "tdlib"

  resource "python-telegram-patched" do
    url "https://github.com/paul-nameless/python-telegram/archive/refs/tags/0.14.0-patched.tar.gz"
    sha256 "7f3af4cb722f37bd65b0a49da448b7d26afa7f2de761aed4828018155e2e78b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config/tg/conf.py").write("")
    assert_match version.to_s, shell_output("#{bin}/tg -v")
  end
end
