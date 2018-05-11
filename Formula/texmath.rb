require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.11/texmath-0.11.tar.gz"
  sha256 "2e6d296edaaf6a71397962f0e750964a2e141caf655f6616d1708dd068525aeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "cce02a7c127d379b73b26b7cb3d77485da516736d7c172d43b52f352af6edad3" => :high_sierra
    sha256 "995da5bba64c8a53fb8cde2596ee736281289239569243e605d90100447b8684" => :sierra
    sha256 "76e39c012334b58dd7be5319d2e6bbfc2633a7bbf4a23cc5b876e3634ccb9804" => :el_capitan
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
