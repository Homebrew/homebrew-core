require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.4/texmath-0.9.4.tar.gz"
  sha256 "da665d069708679fb40ee2e981dcdede55e79f3165c0ae09c55621273e682195"

  bottle do
    sha256 "0bd0eab4170d18ec6e8cc3c50ca456f8c72bb594b06263f17f5d06af587f1e2f" => :sierra
    sha256 "33f120135a7c3af74287243632a61db17f56b45d64d59f4120192134b8959afb" => :el_capitan
    sha256 "81c65e6a4aa0fc4f5d354459c4f04aae266ce8f86d94c646f351608c55fc8274" => :yosemite
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
