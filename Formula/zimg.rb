class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.3.tar.gz"
  sha256 "09962385f986dbcfd8ed6160cdafc2bc57bef8c6bfb3ca3a4bcaa482f09c06fa"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "7ca6312ba8416e46c43ba8a14cedbd98b3bd331386d045235d22e5ea32b9dae4" => :sierra
    sha256 "13cb75cf9289ec4475deb11f5ba35ca06dd40137d17de8d00b4ae001ee9a770d" => :el_capitan
    sha256 "133e3062cb99bbb8d88380cedde2878474165bc6fbb9fef3e7d49dfa20dab766" => :yosemite
    sha256 "d1bddc6475030a82c133e749b5bd448d160be8e039b662001b872ac1513e7ddb" => :mavericks
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
