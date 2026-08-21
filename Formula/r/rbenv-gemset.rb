class RbenvGemset < Formula
  desc "KISS yet powerful gem/set management for curious engineers and Ruby hackers"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/refs/tags/v0.5.102.tar.gz"
  sha256 "193f560fe169b338a63d0bc38cc56ec05bf8639f47073ba487352b1058668e5a"
  license :public_domain
  head "https://github.com/jf/rbenv-gemset.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73ada56ebe65aba98d7479f24cbab0c58808c09c97c76d7e32796087f2a324ae"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    output = shell_output("rbenv hooks exec")
    assert_match "exec.bash", output
  end
end
