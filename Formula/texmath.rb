require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.3/texmath-0.9.3.tar.gz"
  sha256 "541624a64a2dee55e87ce361a66fdd3c82856437b19e2a7c113a04cb7cbc8a7e"

  bottle do
    sha256 "5ec05f487d194e034a902a987270e2cb1927ec7a35fe066c3622027b9f7d8f4a" => :sierra
    sha256 "42810952e76ea60967328647814312d74268ce0d393fff1aa60862c08fb3796c" => :el_capitan
    sha256 "a8e52c0cf027ea9073301a38f76ef29cebb67db3bd3fa253c37f5d5700dfbc63" => :yosemite
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
