class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-2-1/singular-4.2.1.tar.gz"
  sha256 "28a56df84f85b116e0068ffecf92fbe08fc27bd4c5ba902997f1a367db0bfe8d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "b3bcbed0cffc2751cb4e7422987dae763c7bb5fefb6da4e172182296f56d3f1d"
    sha256 big_sur:       "a344fa6e1ecd01461fa59ddb95863581b85749ef9802f3d6f7d79032b26cf9e8"
    sha256 catalina:      "7b9172e57c84672c1aa97a2a09e075a193a064fa3af3678df79b33e0fb0565ef"
    sha256 mojave:        "9bfe6a7938e60280130ba2042a6c1a95840dcadaf65832b5aa6906e738263fe3"
    sha256 x86_64_linux:  "37c4ecf472f68670c963b85fb8271aa8e9baabd274e77872af5aa2aa185ec477"
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
