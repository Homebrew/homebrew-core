require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.3/texmath-0.9.3.tar.gz"
  sha256 "541624a64a2dee55e87ce361a66fdd3c82856437b19e2a7c113a04cb7cbc8a7e"

  bottle do
    sha256 "851139021f7ed5f528df459f77391979961937ab6b037d6834ac93e6072ea61c" => :sierra
    sha256 "161e6a7fe56ff4909ffffbf52e829f1bbb59a175aa81527cbc6dec415e18e476" => :el_capitan
    sha256 "8ae541b51ac922e708e4b710a8436cd746af6059a39f8957b1e174c2a4018a15" => :yosemite
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
