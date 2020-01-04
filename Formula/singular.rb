class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-2/singular-4.1.2p2.tar.gz"
  version "4.1.2p2"
  sha256 "07b22773d982d43687f15ba73de7968d23cc15d2c8f23434742134f7bfc68ef5"
  revision 1

  bottle do
    sha256 "f24e67d674d8f21008582d9c030930ec386cca36f23845e5a0c33f27a59ce207" => :catalina
    sha256 "811ab9b4b292ffc378d8bca7f1c341e7284eb5b42457198cf94e75a20282722b" => :mojave
    sha256 "451a9411c65ce2079c3cc88d5064255696fc2a81cd0213ae96e82f69dc5863ec" => :high_sierra
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
