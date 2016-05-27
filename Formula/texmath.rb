require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.6.3/texmath-0.8.6.3.tar.gz"
  sha256 "74f600a77a5ce2d88aa1aa81b0bea5f5e79da6b64b51e50656f7bbf27debc22b"

  bottle do
    sha256 "918f6900fe1de5b3aec79a3235f36e9568b0f3813bfa5ca4cd0cab940e282042" => :el_capitan
    sha256 "5df6efcd9d088e8e572bff63824f992cfc5ca024546165c9908c4363a3a6361a" => :yosemite
    sha256 "7d81c8e4f6c6bc56017ae573cc6eba4f068e2cfdce669472492a5a23d3b0d672" => :mavericks
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
