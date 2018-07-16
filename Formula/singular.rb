class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-1/singular-4.1.1.tar.gz"
  sha256 "3792c5707b60c1748298bf47e2277de20303d60563b797372cc0e1eff4bbc583"
  revision 4

  bottle do
    sha256 "695da9d8db7a10a8efe0b7b13c8ef1f479677eb2e37b010e52ea5906d18e77e8" => :high_sierra
    sha256 "a52137e6fd32a381216d0b2720c674e0b0f8d685358e9c4de66764d1d513a408" => :sierra
    sha256 "a49697018b4f0e9da93ac881630de616592803c5453beb7a515720d5cedc1910" => :el_capitan
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
