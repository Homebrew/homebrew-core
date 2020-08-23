require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.0.2/texmath-0.12.0.2.tar.gz"
  sha256 "2fec285a2266e56bba17914c122045f31b38de3efcd202dcf32a4f8b830bd184"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d87a2122991899db8297059dad21aef07d3d74f21659ffb49387b4f8d5f7670" => :catalina
    sha256 "76ee2dc264cb8697ceb21c7a52132af5fd2fa46c1340055e7e778a98047cf807" => :mojave
    sha256 "c73f655501e17551219bf6bd028aedaa09b40464b3706db4d1a0d12b673c824e" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package "--enable-tests", flags: ["executable"] do
      system "cabal", "test"
    end
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
