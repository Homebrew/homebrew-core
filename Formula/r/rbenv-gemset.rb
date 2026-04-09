class RbenvGemset < Formula
  desc "KISS yet powerful gem / gemset management for rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/refs/tags/v0.5.100.tar.gz"
  sha256 "371fc84e35e40c7c25339cb67599a0a768bc7d3d4daafb05e02ab960bde64ce4"
  license :public_domain
  head "https://github.com/jf/rbenv-gemset.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ae346537f0186825a566e2da02b193821794883757f26eaf5cbb150e7600a1b"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end
