class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-1/singular-4.1.1.tar.gz"
  sha256 "3792c5707b60c1748298bf47e2277de20303d60563b797372cc0e1eff4bbc583"

  bottle do
    sha256 "c67c0b7d360c347230b0b6fb30f73721ea4630bc5b80a7a2212d74a418d79320" => :high_sierra
    sha256 "3744b2d21c4c3bca155a84678f8ba119bf362ffb721f05f735b88b45f26b639c" => :sierra
    sha256 "851f5dd71d837f2e89e83321e528c1082d2ca4d18ab00f0ebec91ca2947502cf" => :el_capitan
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
                          "--prefix=#{prefix}"
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
