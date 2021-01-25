class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-2-0/singular-4.2.0.tar.gz"
  sha256 "5b0f6c036b4a6f58bf620204b004ec6ca3a5007acc8352fec55eade2fc9d63f6"
  license "GPL-2.0"

  bottle do
    sha256 "26709b976c059b3cd9ebd8b3a5c397d6379503786dbd282a7b25a69af612cb1a" => :big_sur
    sha256 "51ede0e2a1ab0fbdef4bfd7fd9136865bf10c9378a01a7f2517c469d90bc8ef8" => :arm64_big_sur
    sha256 "bcbff484908f20d9677e051686bf44822430a12b18e4f8ec44782977f5ca1d2b" => :catalina
    sha256 "f3e2e200d751f2b7d39d011388a4b2c7cb59ac67bf7ea3583b200a677ee9938c" => :mojave
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
  depends_on "python@3.9"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@3.9"].opt_bin}/python3",
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
