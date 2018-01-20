require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.10.1.1/texmath-0.10.1.1.tar.gz"
  sha256 "52c9638e06ea66a6b75d1d3cce4eb0ebad66af5ce3e53c6c90a6b1564ba34e60"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b0573dcb4396b48266067db73ac5c47f478ae2cd138f248258e6a1b0ce9c8a5" => :high_sierra
    sha256 "3b52bd95759dfbe1ac92424eb6abae0b23894b421bda37fa6101e45dd9a08129" => :sierra
    sha256 "e6da2e8d126caf9cfd99d46d6c3f34810e22a9615e1b2d1aa9ca8ba64afd8475" => :el_capitan
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
