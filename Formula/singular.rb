class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-3/singular-4.1.3.tar.gz"
  sha256 "8191668116e11537116fb2c85d52d539ac5b4ca758187a9edb337288b28f7f28"
  revision 1

  bottle do
    sha256 "453c0c8c3250867758a60e9add2b8b127b6174e80169c98a012cc4bacb2f05e6" => :catalina
    sha256 "0ead6adcc704ea4d073e698a40d9d37641f7b1df7df29a6c3eb48220dba30493" => :mojave
    sha256 "085d8a5dfc3e39376fa448e0dc2348d7d8da6f68dc879c1d57a90b6f468f5464" => :high_sierra
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
  depends_on "python@3.8"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@3.8"].opt_bin}/python3",
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
