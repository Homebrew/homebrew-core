class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-2-1/singular-4.2.1.tar.gz"
  sha256 "28a56df84f85b116e0068ffecf92fbe08fc27bd4c5ba902997f1a367db0bfe8d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "572bb81755f0b7af0657d97a1dab4f34e76f9d56950345aa6be711c139abea68"
    sha256 big_sur:       "4aff7bd1cc68f2c55c65721a545f6757e08787d451983887395bc01f7300497b"
    sha256 catalina:      "ced038f600f6e87f538777c4912301613808fd9d8d6b87925086fc390728ab0a"
    sha256 mojave:        "3d09e569067e2a4b6d3784cf08925079f42be9d7ae02b334ecb17eea7814dc42"
    sha256 x86_64_linux:  "c87843c7be3f7a91e742917916f334fc6d9cbf1e735e25c25efc164c2703bc42"
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
