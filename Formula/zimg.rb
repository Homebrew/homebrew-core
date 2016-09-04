class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.2.1.tar.gz"
  sha256 "0ac3004f7612f91e2eda1aaaf170c2ceef4f90f881647b8e248f36b0e6954f54"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "1451133127fe278b699906c8e7e345a7d5717fc61fe95aceec7aab7c071ecdb8" => :el_capitan
    sha256 "a863b2c60d05fa9238ba9a07e21aab2fe9c8daab0a80d1c1247991122e8210dc" => :yosemite
    sha256 "8300801f5849075c3251b3a0dfc5cdfad7b886894eda23fbb89a9d0fa2269d69" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  needs :cxx11 if MacOS.version < :mavericks

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # Fixes "error: use of undeclared identifier '_mm256_cvtph_ps'"
    # See https://reviews.llvm.org/rL254528 for the underlying cause
    # Reported 4 Sep 2016 https://github.com/sekrit-twc/zimg/issues/52
    if MacOS.version < :el_capitan
      (buildpath/"brew_include/immintrin.h").write <<-EOS.undent
        #include <x86intrin.h>
        #include_next <immintrin.h>
      EOS
      ENV.prepend "CPPFLAGS", "-I#{buildpath}/brew_include"
    end

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
