class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-1/singular-4.1.1.tar.gz"
  sha256 "3792c5707b60c1748298bf47e2277de20303d60563b797372cc0e1eff4bbc583"
  revision 4

  bottle do
    sha256 "5a90a68c177c836bed7b326c055ac9993e434e901f03a7f4c69b24a01e97c2a0" => :high_sierra
    sha256 "7796c1f3a504c602d99c512506e2b21ddcd4858e791b1dba8faec3aea46954b0" => :sierra
    sha256 "2d3e2f6e6e39212f015839190254bd8ab93d2ce3422b56daeb9a71e45e779ab5" => :el_capitan
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
