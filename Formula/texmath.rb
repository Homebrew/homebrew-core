require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.0.1/texmath-0.12.0.1.tar.gz"
  sha256 "ba6b3bbddd46f91a7fe56e1f168060b6843c6f5eaebb2147f5640c6177b854c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f78d7ac53e087522f2a8dbd1baa05f1f40c462e75185e19e9930aae1f9efefbb" => :catalina
    sha256 "bd0c24bbe1f43ffbe9ecd672a639605cc65a6e6c0799bf9f8428a44b0e13e4bf" => :mojave
    sha256 "416ce61d13a1490a5914eed52fb6f92c441a765ec492ba0a65ce81e22770139d" => :high_sierra
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
