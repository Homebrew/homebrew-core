require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9/texmath-0.9.tar.gz"
  sha256 "6ee9cda09fd38b27309abf50216ae2081543c0edf939f71cc3856feca24c5f2c"

  bottle do
    sha256 "eec4b7dd743c4f91341e6c6d92224a76933178f4e47fbc79de25eb0a96969b1c" => :sierra
    sha256 "483c6eca01f5bbdbbb234090c1ad77d6431467d2ce1c92da0355ea63a7954af9" => :el_capitan
    sha256 "d437e40a5459f7ecc4a605d7fb7aa266be59102884ef40b316163ee680d0f744" => :yosemite
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
