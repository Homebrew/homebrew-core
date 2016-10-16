require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.6.6/texmath-0.8.6.6.tar.gz"
  sha256 "9c78e53e685b4537a39a4d2bc785df1d0d0ee775085bd532d8ae88d10d4c58b4"

  bottle do
    sha256 "eb4644a054fe9e0a0edd63941defb462d9ff6bbdd5b4a5c6c2253150c9e357dc" => :sierra
    sha256 "e65c198797e53e828555a43ff0d5c99b61b428011a7e16c15135e479311f76b3" => :el_capitan
    sha256 "961706b26ef7b59b465eac7dca6e0a66ff312453ce9d36d92bf81f6f1b5960bf" => :yosemite
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
