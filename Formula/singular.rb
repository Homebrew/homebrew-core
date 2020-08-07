class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-3/singular-4.1.3p2.tar.gz"
  version "4.1.3p2"
  sha256 "ee7ac6076d7f8622a1f24d37e9b632bae0700c6e314f56728400be136df64494"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 "ec4a73d624d17771e510be59ee936fdb6575a6651292a95797f3f92f167042c3" => :catalina
    sha256 "b1f33f87b56645ba798dddc2ed4492d50dacb02aa8142e6052802e6b6197a711" => :mojave
    sha256 "ffc36b5ecccb30537bf16f92e1321d51eaaa9d5faabca727eb4ba2a2f3d555c3" => :high_sierra
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

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
