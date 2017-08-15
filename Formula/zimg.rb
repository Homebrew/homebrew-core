class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.6.tar.gz"
  sha256 "dc505ec31ee7c67a32056288a729469ff83978586d731b753d5459629f0535c3"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "5fa60bc4b834f2e6ff5891f1881d73fed706a11b3d4fa2ebf9312e041f5b0ceb" => :sierra
    sha256 "4018003a418a9c223e70108856910ecb5d3b06b2d2a1f04dff9712f4d11a6407" => :el_capitan
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
