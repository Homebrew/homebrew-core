class RbenvCtags < Formula
  desc "Automatically generate ctags for rbenv Ruby stdlibs"
  homepage "https://github.com/tpope/rbenv-ctags"
  url "https://github.com/tpope/rbenv-ctags/archive/v1.0.2.tar.gz"
  sha256 "94b38c277a5de3f53aac0e7f4ffacf30fb6ddeb31c0597c1bcd78b0175c86cbe"
  license "MIT"
  revision 1
  head "https://github.com/tpope/rbenv-ctags.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "acdf1a395103d51020679c824c8ad3b9daf794c73ea19fa23906ad6d1938114f"
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
