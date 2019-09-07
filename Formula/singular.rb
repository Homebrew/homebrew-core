class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-2/singular-4.1.2p1.tar.gz"
  version "4.1.2p1"
  sha256 "b520809ce061059081a973d4a3b102b05863d49c20565d03f638ba5146296d4f"
  revision 1

  bottle do
    sha256 "642e7dc5dd1dbf7e7f74559265d1eaaaa2f88fee0aa2c4254bd4d8eaec58b8db" => :mojave
    sha256 "924c9b50467e4c1fa804b9ee1ca47c6694ba8cbb7cc7c7aebbde32ea3c5ff9b7" => :high_sierra
    sha256 "3b471a2db284f9451f4fdce18dba1eb65dd6823da9859281be3e01f86c0470ac" => :sierra
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
