class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-3/singular-4.1.3p1.tar.gz"
  version "4.1.3p1"
  sha256 "5c527d8ed244a4ae74cb98b718deac58c09b0bd75d6ed7fc1ded1ec865ae02b8"

  bottle do
    sha256 "0a6accd0f1c272885fd7a680c345b32001d74b59f2a8b59c4922c76ce2db0e6b" => :catalina
    sha256 "d36ad45835c2a4dc3bf019bbe6c6a046c5808cf0ed4af621de80f4d4816c46fa" => :mojave
    sha256 "81d7c0c02e3cc3e9870a6b8ae898f20dafd9f50fdecad129909c8e4bdc984dbf" => :high_sierra
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
