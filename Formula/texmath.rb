require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.6.3/texmath-0.8.6.3.tar.gz"
  sha256 "74f600a77a5ce2d88aa1aa81b0bea5f5e79da6b64b51e50656f7bbf27debc22b"

  bottle do
    sha256 "0ab6832982913be0f60bb69e6dfbe6eeeb5b8afc4d5a5b485bf46073ce15ccde" => :el_capitan
    sha256 "a03d0dedee2485314258ab26fc8c53c54f23dee39b4171ab684c8c82b78d260b" => :yosemite
    sha256 "27f77c1e3f0d9a2ffa939be94063911aaa6780fdd428cd9d4a13536c846f67bc" => :mavericks
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
