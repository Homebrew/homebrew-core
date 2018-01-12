class WCalc < Formula
  desc "Very capable calculator"
  homepage "https://w-calc.sourceforge.io/"
  url "https://downloads.sourceforge.net/w-calc/wcalc-2.5.tar.bz2"
  sha256 "0e2c17c20f935328dcdc6cb4c06250a6732f9ee78adf7a55c01133960d6d28ee"
  revision 1

  bottle do
    cellar :any
    sha256 "53a5f916c3840f5f3742c5a4e2b9e30f6e4d1befa335a38e29e5e29619c1a0d7" => :high_sierra
    sha256 "c7de145bfc785fe7c5ab006a6d64f19bd11d199e5bf0d0c0973d598717d6c8b3" => :sierra
    sha256 "67160a91e50ae33f723ead45c4150750b62b3bd45ec009eb4b493e138d2a908d" => :el_capitan
    sha256 "1737fad1cd9e5beac6f3a06057bd594b4de2c6b9f709544acd4825fae9160632" => :yosemite
    sha256 "14bcdc8bb396d6c3890a7a7719d6619911ffe92e8949278865b256eb5f74682e" => :mavericks
    sha256 "0eb8fb2e15ee8274ec673850eb5004654e3f7c3d3a835597b5809e87420db08f" => :mountain_lion
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "4", shell_output("#{bin}/wcalc 2+2")
  end
end
