class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-2/singular-4.1.2p1.tar.gz"
  version "4.1.2p1"
  sha256 "b520809ce061059081a973d4a3b102b05863d49c20565d03f638ba5146296d4f"
  revision 1

  bottle do
    sha256 "20523ce9de4f5b0785093b9feffcbc7f80b011aca893e83ea80d5896e2300892" => :mojave
    sha256 "c23b5d7053a5f1ff939b20bd43fa29e8a2381c884d58b1e03f3e0a089d5f352b" => :high_sierra
    sha256 "ae11ffa3c011fc42916658e246a2d1d1a3f54ea8c7a181327265ba0585ac4e0a" => :sierra
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
