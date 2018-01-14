class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.7.1.tar.gz"
  sha256 "fa1d59a2a1ba330e4f3e0460e913fe41dfdf9c6ae950ffb7b73b531fe18ead8f"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "120a1e753e19cc0edc62f1d58bfce944aff7976a486f62694ba8161f68784aee" => :high_sierra
    sha256 "bf01f2ef0efd732ea9be962681c82c75f99087981a5f2cbb1914008c2dab0022" => :sierra
    sha256 "f4a8373462f8bbde5114e64cd0c50bf799f22b0013628093548e15e756267a7a" => :el_capitan
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
