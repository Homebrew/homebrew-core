class RbenvAliases < Formula
  desc "Make aliases for Ruby versions"
  homepage "https://github.com/tpope/rbenv-aliases"
  url "https://github.com/tpope/rbenv-aliases/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "12e89bc4499e85d8babac2b02bc8b66ceb0aa3f8047b26728a3eca8a6030273d"
  license "MIT"
  revision 1
  head "https://github.com/tpope/rbenv-aliases.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1478142388cffd4c60833cdc2b6e7f3bcac3f6e8b15e095167718ceb0cd7c237"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "autoalias.bash", shell_output("rbenv hooks install")
  end
end
