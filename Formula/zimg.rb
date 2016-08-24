class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.2.tar.gz"
  sha256 "573ef25858623d90158f829d1fa66d4ef429a005034cae7a9dc3e9d250b9abf7"

  bottle do
    cellar :any
    sha256 "1451133127fe278b699906c8e7e345a7d5717fc61fe95aceec7aab7c071ecdb8" => :el_capitan
    sha256 "a863b2c60d05fa9238ba9a07e21aab2fe9c8daab0a80d1c1247991122e8210dc" => :yosemite
    sha256 "8300801f5849075c3251b3a0dfc5cdfad7b886894eda23fbb89a9d0fa2269d69" => :mavericks
  end

  depends_on :macos => :yosemite
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" if DevelopmentTools.clang_build_version < 703

  needs :cxx11

  fails_with :clang do
    build 602
    cause "incomplete C++11 support"
  end

  fails_with :clang do
    build 700
    cause "incomplete C++11 support"
  end

  def install
    ENV.cxx11

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
