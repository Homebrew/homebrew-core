class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.6.3.tar.gz"
  sha256 "a701e9ffbe3ad379e84d8720cf6220afb9c6946d761048fb77544325870cc2cb"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "5f4acb7a03af052e97208d91798ae42a5cb98b4cd4d25bdc7e4e837eba9176ca" => :high_sierra
    sha256 "89c0003ecb6375fd42956dc809857fe90211e9b753846052e5f5aa9eae3de927" => :sierra
    sha256 "a63f4fe4f6fef34942f3ebb5fb285c0380323578f8a1b00c111ecd4e7203c6e2" => :el_capitan
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
