class RbenvCtags < Formula
  desc "Automatically generate ctags for rbenv Ruby stdlibs"
  homepage "https://github.com/tpope/rbenv-ctags"
  url "https://github.com/tpope/rbenv-ctags/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "94b38c277a5de3f53aac0e7f4ffacf30fb6ddeb31c0597c1bcd78b0175c86cbe"
  license "MIT"
  revision 1
  head "https://github.com/tpope/rbenv-ctags.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "b002adad54827245a53792a5da722075e8662e65cde9ce26a628510a6b1b3ee6"
  end

  depends_on "rbenv"
  depends_on "universal-ctags"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "ctags.bash", shell_output("rbenv hooks install")
  end
end
