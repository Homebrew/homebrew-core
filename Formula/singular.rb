class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-1/singular-4.1.1.tar.gz"
  sha256 "3792c5707b60c1748298bf47e2277de20303d60563b797372cc0e1eff4bbc583"
  revision 5

  bottle do
    sha256 "5066f4d8f37460e4c742448904bc0ab86f6c80a33403a8166519e2106d1269c6" => :mojave
    sha256 "26d97d795cb78e7970766a0838d82cdb83bab2c6364cd0335a35ad8b818ac2c2" => :high_sierra
    sha256 "d59170be2fc20723900b78e780efc5b56857eae053683b4e5d52670d5db5e1bc" => :sierra
    sha256 "a31f9779b2572c5e15f8f667c4ab4e32e3c89214d4488193cca66637b36e31c0" => :el_capitan
  end

  head do
    url "https://github.com/Singular/Sources.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "CXXFLAGS=-std=c++11"
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end
