class RbenvDefaultGems < Formula
  desc "Auto-installs gems for Ruby installs"
  homepage "https://github.com/sstephenson/rbenv-default-gems"
  url "https://github.com/sstephenson/rbenv-default-gems/archive/v1.0.0.tar.gz"
  sha256 "8271d58168ab10f0ace285dc4c394e2de8f2d1ccc24032e6ed5924f38dc24822"
  revision 1
  head "https://github.com/sstephenson/rbenv-default-gems.git"

  bottle :unneeded

  depends_on "rbenv"

  # Upstream patch: https://github.com/sstephenson/rbenv-default-gems/pull/3
  patch do
    url "https://github.com/sstephenson/rbenv-default-gems/commit/ead67889c91c53ad967f85f5a89d986fdb98f6fb.diff?full_index=1"
    sha256 "eb334375bf0adbeaacdce58ba8b5fd3021258ff7dfdde3dd6683ccd731603ba0"
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "default-gems.bash", shell_output("rbenv hooks install")
  end
end
