class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.1.tar.gz"
  sha256 "c50a0922f4adac4efad77427d13520ed89b8366eef0ef2fa379572951afcc73f"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "9128cde1d368e3c49175038e1dad989b68dce0385b582a4405018051bd403108" => :catalina
    sha256 "3ae619fe7074ba0c4dea5e6eb9e8066ac4c34d5ac43053babb9c9693b39f1aeb" => :mojave
    sha256 "d9748d016f77d29cf855d33fd0af95da9e21bc7edeb479c9e48ef8f895646f79" => :high_sierra
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
