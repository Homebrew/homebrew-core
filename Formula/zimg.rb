class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.7.4.tar.gz"
  sha256 "5182544ba42001613ffa8fd54dac2e8738639339f4bf070a53a4ebf17fdb2a97"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "ca9c8e759ef76b65a44e03ccf978fec1ee435d5ec31ca8057a1b34a6231c8c68" => :high_sierra
    sha256 "24a6502b1ca5b15b991cc3df1f6f4dff7c1966da91560f6e03e03a61f0659787" => :sierra
    sha256 "79ced4a944ed9cd14df5f691b7cb4aba544b559123387d8983758914da5adfd4" => :el_capitan
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
