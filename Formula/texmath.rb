class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.1/texmath-0.12.1.tar.gz"
  sha256 "47d821a885cbdd7f1b4d020f4699636abc345a55ef28793be0c0792ec913e5de"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f091dafb8c9967d2a47b85f45361e60eb7c85b88b8346d76cb2db8a757a1f776" => :big_sur
    sha256 "2769946483f9d19111f011337b7a25f2cf46145ddc86990fe58c311194be0eb8" => :catalina
    sha256 "a155b6bad3842722d5bdbe2fa22be5c10aa191ab44ebaa63000a921acef24b1f" => :mojave
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
