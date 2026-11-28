class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/6e/7c/9250bf071eb9d0012998b774bbf5743a09c715ab5dfd50460c8ba09c2564/unoserver-3.7.tar.gz"
  sha256 "b05f9578506ac7374ae1b314c3a79528636c542ac78220a9ce99110584ca424b"
  license "MIT"

  bottle do
    rebuild 1
    manifest_sha256 "12c9bbbf2e89065c28a99509911e49e676f1bc5059cd497eeb1eda41a1b84f57"
    sha256 cellar: :any_skip_relocation, all: "6ad558a70421755b9353b4f05772c95a72737598b07f5956a9f07feeeeadd4ea"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end
