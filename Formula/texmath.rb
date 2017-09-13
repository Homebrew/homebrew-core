require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.4.1/texmath-0.9.4.1.tar.gz"
  sha256 "302202b2c896403963aefe63044ca65ca277482d0e661607010ca3bf8d9a9d04"

  bottle do
    sha256 "64cc76e382d392a69864d1d5da95a1c1b862fdd9a547d2553f08f054d42ef15f" => :sierra
    sha256 "cb3f8ea701cbb7e19a9d2d0484795c2a9bc4ac431e89bbc18954907bbb6b3e43" => :el_capitan
    sha256 "94138d1753ba7b996faa23e437ab594d5908f32e221360dbb8b3e9a65001a6b7" => :yosemite
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
