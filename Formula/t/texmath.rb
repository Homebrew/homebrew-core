class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.10.3/texmath-0.12.10.3.tar.gz"
  sha256 "57e43a897c1864e1fae6b1d75c055de6cd7c9e3ca4d839d89cc2f6a8fa2ffb76"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fffd29d2900a439c18f683ce3ba237692c81d99324fc562f98cbecc8062cf281"
    sha256 cellar: :any,                 arm64_sonoma:  "1d5e59d046f856059cd425fbecbbe767929cbb58b2c04d3baedc66086c0a63c8"
    sha256 cellar: :any,                 arm64_ventura: "f0d26dbce0a73764d25386aa39482289020f083c54f499f82817d17f2ab77f48"
    sha256 cellar: :any,                 sonoma:        "1bf9cd2a5a5820102ec94c41df19b54883f2878abde1ce23fec221e85f950584"
    sha256 cellar: :any,                 ventura:       "e94147df60f1060730f074328bd38f095f3fe717f74bbcc97358b62b3847b71f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e76532111be584e74fbc0ecd8efe48b8ba0750defeb25d801e3fcf0fb15841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4063e078ad59612d869654d8e0bd1ab9c249df99d1112340f5f9242d146d0391"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
