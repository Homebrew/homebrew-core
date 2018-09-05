class WCalc < Formula
  desc "Very capable calculator"
  homepage "https://w-calc.sourceforge.io/"
  url "https://downloads.sourceforge.net/w-calc/wcalc-2.5.tar.bz2"
  sha256 "0e2c17c20f935328dcdc6cb4c06250a6732f9ee78adf7a55c01133960d6d28ee"
  revision 1

  bottle do
    cellar :any
    sha256 "955d80417eea9747844f52b13d91005f207a869e04f49a4a8f1e1db7e8acfa74" => :mojave
    sha256 "be1800e5bb6cbf1e8087a0310ba648ec80f5013081d8db1145011c2c826b3c0c" => :high_sierra
    sha256 "f934e56de20012d05890525117377efd717ee9d1f09feada9cb41068791065ba" => :sierra
    sha256 "f9b1cd0799ffed7d47cb467d6a9ba606208ec93f263180eb094713ef0bec2bfc" => :el_capitan
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
