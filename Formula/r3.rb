class R3 < Formula
  desc "High-performance URL router library"
  homepage "https://github.com/c9s/r3"
  url "https://github.com/c9s/r3/archive/1.3.4.tar.gz"
  sha256 "db1fb91e51646e523e78b458643c0250231a2640488d5781109f95bd77c5eb82"
  head "https://github.com/c9s/r3.git"

  bottle do
    cellar :any
    sha256 "f136221b1d7a0a4ee057ea0551a2b742d1a49cb50011e5651e8fa5c96327b0b0" => :mojave
    sha256 "5239e5302b1952367f6cdc066e43483de6b0d30fa70f1dcf2e9f03b10983890f" => :high_sierra
    sha256 "d39c22ae9e69454cc7c205ff0cecc3dd6084a38a1e1742091f55df389e5a8f4a" => :sierra
    sha256 "6122bbc3566581f130e54cd563ed69f169598f5ce62d6319e7b5a95b10b802ef" => :el_capitan
    sha256 "56a37f8cab8af3833eb52c6fc739027ffd755fb0e60530bd96dc643bdb8e18ed" => :yosemite
    sha256 "26bd4bc4114b54d57d9f39bd00f15914f03eea7407fbcc50df4c1925b412a879" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jemalloc"
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-malloc=jemalloc"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "r3.h"
      int main() {
          node * n = r3_tree_create(1);
          r3_tree_free(n);
          return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-L#{lib}", "-lr3", "-I#{include}/r3"
    system "./test"
  end
end
