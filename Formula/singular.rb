class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-2/singular-4.1.2p1.tar.gz"
  version "4.1.2p1"
  sha256 "b520809ce061059081a973d4a3b102b05863d49c20565d03f638ba5146296d4f"
  revision 2

  bottle do
    sha256 "8729b1dc62c815119dcf2dd02c28bd46bff1f6d26b4f94fbe19bcd068bebabd1" => :catalina
    sha256 "c8667a4ade11b37490a21f5ebba2aeae703d8531bdfa7622c4ebd83bc1e809f2" => :mojave
    sha256 "366655725abfcebfd6aac79713aeb568282f5c23509b66dc5154367d2bd13934" => :high_sierra
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
