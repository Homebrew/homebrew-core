class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.7.3.tar.gz"
  sha256 "c0b7d719338d86bf69c688fcea451a6d81d93551fa9e305504f7e13bdbf7046c"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "767b7d6c8c1591c5e7f2e4d9fdb245c62634c9f822196edb72f3f62fef08eb73" => :high_sierra
    sha256 "0888eb1fc2063346ab6b9a99693cc175d19d0e0972df7884790e68160ccd6301" => :sierra
    sha256 "68a25d0912b8d4c68ee28cc5dd093130d0ea98e3a9c437da225a69999691792e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Upstream has decided not to fix https://github.com/sekrit-twc/zimg/issues/52
  depends_on :macos => :el_capitan

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zimg.h>

      int main()
      {
        zimg_image_format format;
        zimg_image_format_default(&format, ZIMG_API_VERSION);
        assert(ZIMG_MATRIX_UNSPECIFIED == format.matrix_coefficients);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzimg", "-o", "test"
    system "./test"
  end
end
