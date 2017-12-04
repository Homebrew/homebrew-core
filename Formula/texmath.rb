require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.10/texmath-0.10.tar.gz"
  sha256 "ea06e7a8296e11377925c2ff00c41d87b2b22329ab4597b1f974ce1363573045"

  bottle do
    cellar :any_skip_relocation
    sha256 "54602c384f8d0a16184ce9633258fdf8a7d251d77c7dad1197e001df2eb54c72" => :high_sierra
    sha256 "ff7e3ae47f09c826880686731b22c8c99e91eafca96bbb39609c5a7133cd9a47" => :sierra
    sha256 "6c1c4e1c7f513a64bfb933fc4a018c4c252a9e767557f841462ae4a4aa6c7362" => :el_capitan
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
