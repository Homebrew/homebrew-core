class RbenvCtags < Formula
  desc "Automatically generate ctags for rbenv Ruby stdlibs"
  homepage "https://github.com/tpope/rbenv-ctags"
  url "https://github.com/tpope/rbenv-ctags/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "94b38c277a5de3f53aac0e7f4ffacf30fb6ddeb31c0597c1bcd78b0175c86cbe"
  license "MIT"
  revision 1
  head "https://github.com/tpope/rbenv-ctags.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "93ff69e4515aae2a296578472b395c3bc8721fc711327c6f2a9126111910700e"
  end

  depends_on "ctags"
  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "ctags.bash", shell_output("rbenv hooks install")
  end
end
