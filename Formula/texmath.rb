class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.3/texmath-0.12.3.tar.gz"
  sha256 "1d215c20f8b0be2779752f36ee5837ef1b5b37042716713335456bc8b57d0b52"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "820604565c309184e9c3627f2846f5a1715fdf1607fa6647f65e1b1f7bdbee38"
    sha256 cellar: :any_skip_relocation, big_sur:       "5103aa3afe5577ee258878a49075f887c10f704a3267e005b6be77518d27e871"
    sha256 cellar: :any_skip_relocation, catalina:      "821d782521b756be6628037d9848a1080f3acd98cf75585241d3a73f70841dcb"
    sha256 cellar: :any_skip_relocation, mojave:        "9f1fc7ee11583a51ccb981bd0ec238b19b963054e5b58bf47edd5e86098c78d4"
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
