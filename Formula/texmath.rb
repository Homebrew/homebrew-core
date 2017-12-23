require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.10.1/texmath-0.10.1.tar.gz"
  sha256 "72753d867e0b0a1fc7a51d0c30d1b335aa699071b30b17ea06221d078c7d1e13"

  bottle do
    cellar :any_skip_relocation
    sha256 "95fba797e995f4f482099fd9adb087befc4dd7059935db64a7e08ec8bfc871ee" => :high_sierra
    sha256 "45a55a90a9231400b95620fe0f3ce87e58b39e98386eee50af8b6ab4caa096b5" => :sierra
    sha256 "4e14954d9b53163e89ded89a0cc7821a6c9a83f34fea84f26b1a0346c121a2a2" => :el_capitan
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
