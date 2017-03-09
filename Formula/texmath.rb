require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.1.1/texmath-0.9.1.1.tar.gz"
  sha256 "b31e7e9caffdfb50c65297fd1ccda544fa95bc06c1cfe44cd10bddf7e0dc5382"

  bottle do
    sha256 "484fb1878e136839d6e7d1c83db6f425b4da85fc3c4470f7fe9be0f24240e818" => :sierra
    sha256 "78b279b5ffea24b30d179f512060d8d3620cd6787aae9f127dc5f5d6f0acd35e" => :el_capitan
    sha256 "4ce08354d556862a445b0b297d5d70ee8db72fcd2090b4b3ac9f5c80ef81ca3b" => :yosemite
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
