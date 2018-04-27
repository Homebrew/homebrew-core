require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.10.1.2/texmath-0.10.1.2.tar.gz"
  sha256 "fda230b0ce48efb1f45f14c47d3db255466b973f42699507d53f8a7ca8a5d821"

  bottle do
    cellar :any_skip_relocation
    sha256 "989b22c79bfda29a7a477e5f6348b605db9e2dbaf5abdd09b8d3c6ef6a7427e6" => :high_sierra
    sha256 "5b3065e5e4ce285ec4ad84ca69f897774451d63ed930c3c43626bb606cd1ef26" => :sierra
    sha256 "a79acdbf08387619c9a20b8367b2fc42618e99ba5feac401e77c4ab154c7f049" => :el_capitan
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
