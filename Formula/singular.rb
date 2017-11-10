class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-1-0/singular-4.1.0p3.tar.gz"
  version "4.1.0p3"
  sha256 "440164c850d5a1575fcbfe95ab884088d03c0449570d40f465611932ffd0bf80"
  revision 1

  bottle do
    sha256 "293d84d3bac5d54eea0c541a7f23788332db2cc9bd7df87b3ef01755b9ed6be6" => :high_sierra
    sha256 "3d87470f1711bd3e6335dc72b5f0b512686bbebe9374360a5f52f421eef315be" => :sierra
    sha256 "b65566d5a29789f3601fc9074f4436ecc3b51428de7c4a4b7a118c6370b82d5b" => :el_capitan
  end

  head do
    url "https://github.com/Singular/Sources.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
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
