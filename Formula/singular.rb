class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-2/singular-4.1.2p2.tar.gz"
  version "4.1.2p2"
  sha256 "07b22773d982d43687f15ba73de7968d23cc15d2c8f23434742134f7bfc68ef5"
  revision 1

  bottle do
    sha256 "c2be380c490ffaa24b1c01d787c58b32e0e65752fcd17952f0da2905efe8e400" => :catalina
    sha256 "ba4db9eb480106a1268a94cc73c3fdfcce098328d32df9bfd18189776e99b333" => :mojave
    sha256 "f610bd3eb0a16d1c09ab1be979bf9ca9e839262a1cdcab7bec4b825b977313c5" => :high_sierra
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
