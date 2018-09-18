class RbenvCtags < Formula
  desc "Automatically generate ctags for rbenv Ruby stdlibs"
  homepage "https://github.com/tpope/rbenv-ctags"
  url "https://github.com/tpope/rbenv-ctags/archive/v1.0.2.tar.gz"
  sha256 "94b38c277a5de3f53aac0e7f4ffacf30fb6ddeb31c0597c1bcd78b0175c86cbe"
  revision 1
  head "https://github.com/tpope/rbenv-ctags.git"

  bottle :unneeded

  depends_on "ctags"
  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "ctags.bash", shell_output("rbenv hooks install")
  end
end
