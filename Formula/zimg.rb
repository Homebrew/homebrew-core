class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.9.1.tar.gz"
  sha256 "8efa0c381aa6a9bcd5ea4ae22ad06dccf6c1dc705c394547de016951d1946154"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "dc23002712327f9734c9673bbe9da0561a2a3c1f59d8015c296ff6d9a98d3160" => :mojave
    sha256 "73d2f81fe273e86493b82e0b67fdb700896a1010227579b485a005350ea8da7a" => :high_sierra
    sha256 "ba08ff15a2965abb2d02104689f59b35fd561a03fafbf419039ace8a56b2bb48" => :sierra
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
