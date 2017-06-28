class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.5.1.tar.gz"
  sha256 "deb85887081cab7fa9c492b588900d60d6466e61ee8ea51a84ca280688d93de9"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "ae34b81b8865695e8cbf44141ee2c6a4954ed2a0385da0068bf4c28ade67b3aa" => :sierra
    sha256 "59ddab60c928041c9e00efd6c03444dc2ca18dc6a7d35b8f357085e11cf3bc7e" => :el_capitan
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
