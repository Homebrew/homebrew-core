class RbenvDefaultGems < Formula
  desc "Auto-installs gems for Ruby installs"
  homepage "https://github.com/rbenv/rbenv-default-gems"
  url "https://github.com/rbenv/rbenv-default-gems/archive/v1.0.0.tar.gz"
  sha256 "8271d58168ab10f0ace285dc4c394e2de8f2d1ccc24032e6ed5924f38dc24822"
  license "MIT"
  revision 1
  head "https://github.com/rbenv/rbenv-default-gems.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1e1fdba37bf88db84ae56cd101d333b958c3adfab8b0e4515838cf5c3ad6b753"
  end

  depends_on "rbenv"

  # Upstream patch: https://github.com/rbenv/rbenv-default-gems/pull/3
  patch do
    url "https://github.com/rbenv/rbenv-default-gems/commit/ead67889c91c53ad967f85f5a89d986fdb98f6fb.patch?full_index=1"
    sha256 "ac6a5654c11d3ef74a97029ed86b8a7b6ae75f4ca7ff4d56df3fb35e7ae0acb8"
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "default-gems.bash", shell_output("rbenv hooks install")
  end
end
