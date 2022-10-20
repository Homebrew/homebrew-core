class RbenvVars < Formula
  desc "Safely sets global and per-project environment variables"
  homepage "https://github.com/rbenv/rbenv-vars"
  url "https://github.com/rbenv/rbenv-vars/archive/v1.2.0.tar.gz"
  sha256 "9e6a5726aad13d739456d887a43c220ba9198e672b32536d41e884c0a54b4ddb"
  license "MIT"
  revision 1
  head "https://github.com/rbenv/rbenv-vars.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "466046f39e8c68063997f8d1835c4ede73f84452f6e24639a75c599da6303e00"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "rbenv-vars.bash", shell_output("rbenv hooks exec")
  end
end
