require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.11.1.1/texmath-0.11.1.1.tar.gz"
  sha256 "c6f5a6dc010d23c2c38dc4fbc62d7c36d3d1c80d5ceb6a0e4b472b8278f4dbeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "84a9c7b77ccd647ff3c869c94c505d8d143b942ea3c236805621a505cc4c0d01" => :mojave
    sha256 "760e01e12ab44dba38a1e2dba27ce6514f5875fab403b77eabcdede4aad704db" => :high_sierra
    sha256 "486ed9a7ba32823a46744c5b8b46e5edde1ee30ed2259963cd34c6a1949b20d8" => :sierra
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
