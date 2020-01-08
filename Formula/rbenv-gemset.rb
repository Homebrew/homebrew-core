class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/v0.5.9.tar.gz"
  sha256 "856aa45ce1e9ac56d476667e2ca58f5f312600879fec4243073edc88a41954da"
  revision 1
  head "https://github.com/jf/rbenv-gemset.git"

  bottle :unneeded

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end
