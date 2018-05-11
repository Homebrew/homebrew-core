require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.11/texmath-0.11.tar.gz"
  sha256 "2e6d296edaaf6a71397962f0e750964a2e141caf655f6616d1708dd068525aeb"

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
