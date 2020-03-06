class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.9.3.tar.gz"
  sha256 "a15c0483fbe945ffe695a1a989bc43b3381c8bf33e2d1760464ec21d32cdf30b"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "01b1116ebf7b0c065e19a3ce31c92965c361ba964dcc892f6fdbf69d98d94912" => :catalina
    sha256 "7e22530b80432466153372f3d05580cf64d23d5f4fad6825887dad65737092b3" => :mojave
    sha256 "699e5d20544252543c021de24b90aa9daae0f455310e030c485cd29b9eb350c5" => :high_sierra
    sha256 "467810f773bb00aab981b5ad649751b9fe061a555babf15979f08a76b120f3db" => :sierra
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
