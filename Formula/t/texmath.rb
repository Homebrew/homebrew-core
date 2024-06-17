class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.9/texmath-0.12.8.9.tar.gz"
  sha256 "fc7ea4097bea79a5febd681eed91d62e1288e898539e5bdcf4aed6985644a662"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c86ee33fd65d2499aa9f0bf40f9f378dcebe8c1ed037fc39c6f3488f19e8fe15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b30eb58e27784097fceabba0674268d82fd2aa078d967d1cddc003c372f04a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123833376fcb051663570cc39e8463b38ea1a686defdbf1993d722744ebdcf9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a748b20386c2dde1cc398e9b799c1db1907c30d4f810ea4d3eb577e8c20638d"
    sha256 cellar: :any_skip_relocation, ventura:        "0740e3b818361a466281a5905728eba92aebd2ec8d8a255055151c44ab976738"
    sha256 cellar: :any_skip_relocation, monterey:       "7ea7629c303bba272622e27074628f73b1d2f67bd1fad3862a7672d6e881b864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c00529367c9392b925b08293530ae7dc910b8df6cf1803aabfff993a93e84ca2"
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
