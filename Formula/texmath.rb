class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.0.3/texmath-0.12.0.3.tar.gz"
  sha256 "318771c696dfa4fc57edf984f3aa35f0cb1792119cf2e27601b6267d9e1d4918"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e8685dabc26099a084382c2fb5efbba8fe727c606e5c044aa7fda8c63473c07b" => :big_sur
    sha256 "847f9fdad393e1f4689f672b6420e949fd1faa9f24249293c8618208637d8f81" => :catalina
    sha256 "61014281ed8c8d53029d63a5eb6bc83df4eeca96d1738d7e029696ebc712462a" => :mojave
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
