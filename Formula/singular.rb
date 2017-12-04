class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-1-0/singular-4.1.0p3.tar.gz"
  version "4.1.0p3"
  sha256 "440164c850d5a1575fcbfe95ab884088d03c0449570d40f465611932ffd0bf80"
  revision 1

  bottle do
    sha256 "5be41d91381850e9d490e439d86cdf2f93bd308c3e19218164b15f9423c64ef5" => :high_sierra
    sha256 "dd66f9654f6e64479b266885c2b9466474a06bad3e85166010658820980746e3" => :sierra
    sha256 "883ba99583262372b1b5e172319920ec64c0c4f7364ef830386490a9bc4a4914" => :el_capitan
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
