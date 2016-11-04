require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.6.7/texmath-0.8.6.7.tar.gz"
  sha256 "9e5fd9571a7257bdc8cfa6e0da077b16e867011a9f813065d68dd046bd358c88"

  bottle do
    sha256 "e98de0a1e7896f41fc993805fa6a6f98ebe484e43eb2225890a0bac7828daa7e" => :sierra
    sha256 "5e646e9e5df67187ea8e21728e293aea6378a0a064386dcc3bd7ae9a5a96e950" => :el_capitan
    sha256 "3284f13f95e2af5b097e9ba6977a6e14492fa441f5c781124d0f9f4d46a4a76e" => :yosemite
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
