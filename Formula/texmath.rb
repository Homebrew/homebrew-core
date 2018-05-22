require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.11.0.1/texmath-0.11.0.1.tar.gz"
  sha256 "4ec7f6ec41b38d184ca5069440f09ff2b50ff8318809c880f8da79eb6002ac85"

  bottle do
    cellar :any_skip_relocation
    sha256 "a568d5b74c2ec97943e1b0a44e09239aae167b4dcc588a50d4605f414ced964e" => :high_sierra
    sha256 "c535ca7aeb2b97bc594f4b40ba043da8acd4e32d59774469478bb8ac0c852cad" => :sierra
    sha256 "11e33b5482f731bbf4983b1f208a32273cf4b1f85ad8bac9b0b03843ad4fe2c0" => :el_capitan
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
