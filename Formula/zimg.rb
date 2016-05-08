class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.1.tar.gz"
  sha256 "e6d6c6c60b38ebaf74e2ab934b5b90b54e61f34e0a3f111c9da82958335f25da"

  bottle do
    cellar :any
    sha256 "3be1b41723e243ddbe287921f24bc8390281a0d2e642beffd70356ae208db7bf" => :el_capitan
    sha256 "76d9e9579b6aec4cca6c3d5b5472ae2800389b01f1cc2c90998088c7e9a85f14" => :yosemite
    sha256 "7768866e683f5e05098f560fbe2ce44779a88d2ab719fd5af49f9d92a05057e8" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
