require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.10.1/texmath-0.10.1.tar.gz"
  sha256 "72753d867e0b0a1fc7a51d0c30d1b335aa699071b30b17ea06221d078c7d1e13"

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
