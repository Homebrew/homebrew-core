class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.1.tar.gz"
  sha256 "c50a0922f4adac4efad77427d13520ed89b8366eef0ef2fa379572951afcc73f"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "1b86d04d346e073a6f1f10de4df32d8ed38639589ab557f1ca926df3710cf7bf" => :catalina
    sha256 "5e02a6d87423b269cb3068e00fbf133eb0ae5ba519d817fa9b71f76e3d9a24f1" => :mojave
    sha256 "3aa550e35f7b18561cfcea1dff0c9e0d10fba0563f758b73b52f1767763bbec2" => :high_sierra
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
