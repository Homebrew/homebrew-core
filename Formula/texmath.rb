require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.11.2.2/texmath-0.11.2.2.tar.gz"
  sha256 "fe4e24af001104ed3c95ee44076e6819ffad67684efdabee5ae07cf8ceb81087"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef810c923e8a459cc4d18ab596c348e4e8610b177c642242b4bf07915eab7e16" => :mojave
    sha256 "1782096bfc10752b5916f16aa188a37e57609f101f334be92b1abf23bf8ed59d" => :high_sierra
    sha256 "45e18931b08c56b33ec7610ebeae791d5acf496d1e3cfe949dca28162e10c15e" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package "--enable-tests", :flags => ["executable"] do
      system "cabal", "test"
    end
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
