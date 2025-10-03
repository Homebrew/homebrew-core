class RbenvCommunalGems < Formula
  desc "Share gems across multiple rbenv Ruby installs"
  homepage "https://github.com/tpope/rbenv-communal-gems"
  url "https://github.com/tpope/rbenv-communal-gems/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "99f1c0be6721e25037f964015cbd2622d70603ceeeaef58f040410ac3697d766"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a189879cf1fb24dfd135aaf5c9fafe5c4fc1251236da0476be32e7a3a9edb5ce"
  end

  deprecate! date: "2024-03-14", because: :repo_archived
  disable! date: "2025-03-24", because: :repo_archived

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "communal-gems.bash", shell_output("rbenv hooks install")
  end
end
