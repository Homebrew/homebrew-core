class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.4.tar.gz"
  sha256 "219d1bc6b7fde1355d72c9b406ebd730a4aed9c21da779660f0a4c851243e32f"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "67bf243cac048e9834cabe798291937c500bb79406932a438ac1dc02fbd648a3"
    sha256 cellar: :any,                 arm64_monterey: "afc67759e761ce7569c11a844f4af29802880ed9ac955b08a2bd7cfc56133c9b"
    sha256 cellar: :any,                 arm64_big_sur:  "40efe797c81967168a03455886ae5bca77f8fbd887ad852bf6075e9cbea163a5"
    sha256 cellar: :any,                 ventura:        "e830c58c7a65075dbbcf439fc7d2c0d621669ff1781678f7d382acdeb94ce22c"
    sha256 cellar: :any,                 monterey:       "67e43a8f648f630798a701cfce4dabe306c9fed320e272ee7e3108971bcdaf80"
    sha256 cellar: :any,                 big_sur:        "9c106b35b00ef8c6dc27e928d6ab407dc068a86423c246c0fbaf28b7c32ffbad"
    sha256 cellar: :any,                 catalina:       "672bca8794463c7d4debe5cbac9ae5c7b5cd8fc57553f7bcf8a8092603d367b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e46696be2a61e5ee59177aa5f5d7f13944341a7244cd07be9fe7fb7aabfce65"
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
