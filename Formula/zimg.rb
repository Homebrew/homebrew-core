class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.3.tar.gz"
  sha256 "09962385f986dbcfd8ed6160cdafc2bc57bef8c6bfb3ca3a4bcaa482f09c06fa"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "574178eca30bfc624ba7704426e8a376b608d035da2be4d26c4dc35f5376d806" => :sierra
    sha256 "21e70256499ef4f5b1d255537d98e8d563979e8cf3ac16f8b23bdef42e70622a" => :el_capitan
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
