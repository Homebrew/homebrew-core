class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.9.1.tar.gz"
  sha256 "8efa0c381aa6a9bcd5ea4ae22ad06dccf6c1dc705c394547de016951d1946154"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "57afa33acbedd31fe42cf1aa48cda0682b985fcbff5536a2b65c0b75a9506879" => :mojave
    sha256 "34babb4d3249667e24b3ebc6306a389fc7d432b512383ceedd55518cbb7a5e56" => :high_sierra
    sha256 "243c9709bc0b5c0da6392443bfdddb82c30811557f8c344bf64459af05f5ba42" => :sierra
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
