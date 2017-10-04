require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.4.4/texmath-0.9.4.4.tar.gz"
  sha256 "6de2f96d72fb07ea5dc7ad4f846a052f7334d001cbf136cbd8313653ea183889"

  bottle do
    cellar :any_skip_relocation
    sha256 "94e103354f40dee24c7a715ce4bbf19af635c35f317668e58b826e17bb7b1721" => :high_sierra
    sha256 "b7974f892e6967175bf00f7d50ab64b9f8a5664e27953054170e555d0c67cf2d" => :sierra
    sha256 "bf6762b6590315997c4dcb8eebdeef965bd7129f20e3d11deb97a047c4dff5f2" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package "--enable-tests", :flags => ["executable"] do
      system "cabal", "test"
    end
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
