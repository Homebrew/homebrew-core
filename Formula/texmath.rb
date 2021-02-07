class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.1.1/texmath-0.12.1.1.tar.gz"
  sha256 "01be79d6722c53420d9a5c8d0089d9990689ab39c1d964e7ef3ea9fdd77a9411"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f091dafb8c9967d2a47b85f45361e60eb7c85b88b8346d76cb2db8a757a1f776"
    sha256 cellar: :any_skip_relocation, catalina: "2769946483f9d19111f011337b7a25f2cf46145ddc86990fe58c311194be0eb8"
    sha256 cellar: :any_skip_relocation, mojave:   "a155b6bad3842722d5bdbe2fa22be5c10aa191ab44ebaa63000a921acef24b1f"
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
