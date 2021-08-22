class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.2.tar.gz"
  sha256 "b9eadf1df12ae8395ba781f2468965d411b21abbebbebeae3651d492227d4633"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fc7a1db429cbb9baa6ef415c0b2714a339a589ba91f98b7b37b62c0f9e0b82e3"
    sha256 cellar: :any,                 big_sur:       "fc15c72a67c4165aefcfa6ed60c1d233d7746a156aa8829bf7eb45c0bb0e91dd"
    sha256 cellar: :any,                 catalina:      "07d7a2276860b7183034b2b1518bc50c3e695d34467f9efabdef42fe79c822d8"
    sha256 cellar: :any,                 mojave:        "4b46b64c4c3b1105a338aed5b0a17439994cb42f6b301b5b386f2495fea3aa06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb953613c5b38c565bbaf6db31ff76640eadb138459bfcf713f83fe6fc00e1c"
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
