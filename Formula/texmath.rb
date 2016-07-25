require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.6.5/texmath-0.8.6.5.tar.gz"
  sha256 "33f8c3d78f2f46246b64cecab47e27f1f4e587f05b2375e94a8a43dfce446c90"

  bottle do
    sha256 "d2bde4f0afe9a44bffe077126b09ca5e5bfed335cbb5f92843e6a289a0a1dd20" => :el_capitan
    sha256 "6e6e306fcbcf58b9e3cb3327be19fb48bee50793365fdf84abf42cd2a9ccc1f7" => :yosemite
    sha256 "9a2beb5548aa2ef5f4bb241ef2c000d2666f2eb2d3efd210dc96438a3514be13" => :mavericks
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
