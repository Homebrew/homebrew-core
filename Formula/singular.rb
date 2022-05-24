class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-2-1/singular-4.2.1.tar.gz"
  sha256 "28a56df84f85b116e0068ffecf92fbe08fc27bd4c5ba902997f1a367db0bfe8d"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_big_sur: "abff098b3e9ee836f54f320103eb4a34b418d54dc4776ddfa391c9a698728fbb"
    sha256 big_sur:       "6ee7ee8c292b8916c7bfdb32f8218fe629d11eeaf0fb2fdede9959c219b60726"
    sha256 catalina:      "e28a1b276a609142eeb0d1c61b5530498f740bb840f991c18134e1c6daaeb76e"
    sha256 mojave:        "c7e348e7558c41f959fca63f960143379b6f2c9535d3c769cfe3131f4086394a"
    sha256 x86_64_linux:  "0b05cf52f0373c446904b561bed84b31019915bb101ad11c350736ae710ae0a5"
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
  depends_on "python@3.10"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@3.10"].opt_bin}/python3",
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
