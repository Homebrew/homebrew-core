class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.7.tar.gz"
  sha256 "afc15350bd0072a24dd0ed1eaae832ce606245e3c1f8edd81a81bb6f1bfdda2d"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "f326b3997e550b13480f68237f2c5c4a34c30f65b1d3eab2d059c664ea85491f" => :high_sierra
    sha256 "bd18b073fc29a8ee6028bf82b8535149b130fcd8fcfb41525684865e25ed247c" => :sierra
    sha256 "d6b320246d14ef5736aaae250dce34a5afdbb45d1740c3cbbd39ed3d53425be6" => :el_capitan
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
