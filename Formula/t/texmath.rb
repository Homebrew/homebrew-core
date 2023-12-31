class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.6/texmath-0.12.8.6.tar.gz"
  sha256 "7ba37a07ad3bb64d1dfbe443dcf64575458e403083151591445a2c1ef040da9d"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23d295078905af64c6b35c4ea2a039b28e6252ede0a29ebef4ade1069a6541be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9922cf759afa9c3971bad7a25e3dbc51a376bd688d8019ce0851b8637d45732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be87b1020fac5c2cb8e083f919696dd7ce5021f7a2d156e8571eb9c8979d1dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "92e9a75af7d129ea6770b009d71314a2f9146cc210b72a6495960f16b88fc649"
    sha256 cellar: :any_skip_relocation, ventura:        "87314a9501aa58912eb57d05d370e8bdf4bee3dd93ac5371ff80509ced02f349"
    sha256 cellar: :any_skip_relocation, monterey:       "156c88825d805107f4652bde8bece9539fe5b9ea3353a6a264f81452ae17e6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e95286f15e590237bba721493eaaca07bcc5d37ff4bce3765f4a45cb2b5ff43"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
