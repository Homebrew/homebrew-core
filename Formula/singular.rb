class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-2-0/singular-4.2.0.tar.gz"
  sha256 "5b0f6c036b4a6f58bf620204b004ec6ca3a5007acc8352fec55eade2fc9d63f6"
  license "GPL-2.0"

  bottle do
    sha256 "470cce62a2e4de91b9ddbd6fef610b8c30fa23b6180ba7ad37ee3f5394a6c15b" => :big_sur
    sha256 "75f8a2d324d2d9bff14ec7063ccc23992502f899ddacc6603102dd7e0047f482" => :catalina
    sha256 "6462648583c2d1a3f21e6bcd341ff75ffc6cf9e2a945b80d268093187591dcd4" => :mojave
    sha256 "f0c3ef15a16f9e59290da7ad7530a5c6897aacf2b825b41db5ea4da61bb7cf25" => :high_sierra
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
