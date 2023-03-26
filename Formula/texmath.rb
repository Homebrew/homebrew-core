class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.7/texmath-0.12.7.tar.gz"
  sha256 "1b3e70bc2694fff2fe776921981df6210df79577cedb0e7f5371020e3a38ddc5"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9218cbb4dee29a13455b7fabe79be153b26fcada3a9c16f612cac20514d66fd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fae42feba2ef59284fb037baf2cbe62bd8832bca0a69c6d0c7de263014b4615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af950c39d0f977e1416185f9285db85c993dba170622cb033c3b79ca4e3f1fa9"
    sha256 cellar: :any_skip_relocation, ventura:        "94dd539ab8a939fe2abd94b930c9b53e2348ab43351c72eb20495abcef033a89"
    sha256 cellar: :any_skip_relocation, monterey:       "ae03f1c26d684b8f385966ec3917729c1be50f1eaa27af8146eedc144ed62f80"
    sha256 cellar: :any_skip_relocation, big_sur:        "552ad82f0a98f93e5c1e4f5962701b0d4d63d19d4f6f0f243046156990c0a2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89f39d3b4a56e86ecc23777744f53f5ee287dd8566a0743ec3f197be3edeca80"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
