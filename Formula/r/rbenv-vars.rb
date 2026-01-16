class RbenvVars < Formula
  desc "Safely sets global and per-project environment variables"
  homepage "https://github.com/rbenv/rbenv-vars"
  url "https://github.com/rbenv/rbenv-vars/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9e6a5726aad13d739456d887a43c220ba9198e672b32536d41e884c0a54b4ddb"
  license "MIT"
  revision 1
  head "https://github.com/rbenv/rbenv-vars.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "571e19044f1c058d68271c7a8296cccee968ba6e1e0bca75fe8b5167f5888b96"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "rbenv-vars.bash", shell_output("rbenv hooks exec")
  end
end
