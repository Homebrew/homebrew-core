require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.6.5/texmath-0.8.6.5.tar.gz"
  sha256 "33f8c3d78f2f46246b64cecab47e27f1f4e587f05b2375e94a8a43dfce446c90"

  bottle do
    sha256 "8deb83cbcd5b7dedc49297beba5937ce64b7de22373456f4fc9988425b916aab" => :el_capitan
    sha256 "2936a412081903c52110ea81f230cb251ff36b99e3d41fad331a4145484e8bc2" => :yosemite
    sha256 "2a8b07ff8b7d4cdee9050beb5d6ba8c0ed73e428aa0d6fd3d9e8eec262fa891e" => :mavericks
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
