class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/6e/7c/9250bf071eb9d0012998b774bbf5743a09c715ab5dfd50460c8ba09c2564/unoserver-3.7.tar.gz"
  sha256 "b05f9578506ac7374ae1b314c3a79528636c542ac78220a9ce99110584ca424b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "313e849339cb1051d486a45d86a299573903b7830be534ba1bd43e6873c94df3"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end
