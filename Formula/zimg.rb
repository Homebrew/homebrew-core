class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.tar.gz"
  sha256 "91db478e7271d3267bc79b15a9728c87bff88b1f08741e6701e79b028aa5b01e"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "65da1647208bb9d77aefcf9a2b4413adb1af57fc115f9689dcac02fbc6893fce" => :catalina
    sha256 "efd508b816f4d22b379645878b2aa415bd51883a404145250b6694a951c4b524" => :mojave
    sha256 "75a2ab770e1affcee1f185dd42699721bb9d03ca99cf66f417fff106521786a5" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Upstream has decided not to fix https://github.com/sekrit-twc/zimg/issues/52
  depends_on macos: :el_capitan

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
