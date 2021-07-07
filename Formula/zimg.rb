class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.2.tar.gz"
  sha256 "b9eadf1df12ae8395ba781f2468965d411b21abbebbebeae3651d492227d4633"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "88ce45e66e79aa6e2d0a9455272a3547601c6be259328b009d545b58f0200ce2"
    sha256 cellar: :any,                 big_sur:       "b0b118d35db77d2a1cc8f02eb4b88349835ebe1e714d3bedf1157196a0e921b7"
    sha256 cellar: :any,                 catalina:      "1b86d04d346e073a6f1f10de4df32d8ed38639589ab557f1ca926df3710cf7bf"
    sha256 cellar: :any,                 mojave:        "5e02a6d87423b269cb3068e00fbf133eb0ae5ba519d817fa9b71f76e3d9a24f1"
    sha256 cellar: :any,                 high_sierra:   "3aa550e35f7b18561cfcea1dff0c9e0d10fba0563f758b73b52f1767763bbec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3064bdf353841250b5e87e4bcddbf05843f1c1c5264892ef7851313f40abeb3d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
