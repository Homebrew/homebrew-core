require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.4.4/texmath-0.9.4.4.tar.gz"
  sha256 "6de2f96d72fb07ea5dc7ad4f846a052f7334d001cbf136cbd8313653ea183889"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9f020ed4deb4a7f8ad3aee7ffd6d9a508771aebafb793a96e6e109aa83dd38b" => :high_sierra
    sha256 "e87453cebac34bf834abcde930fe30b31975c0ae3004f6cd7a3b089df50d9010" => :sierra
    sha256 "7710fb277a5a12637e54b464fdf566747636ed726afc2993a50a5c7ec59ac249" => :el_capitan
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
