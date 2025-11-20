class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/refs/tags/release-3.0.6.tar.gz"
  sha256 "be89390f13a5c9b2388ce0f44a5e89364a20c1c57ce46d382b1fcc3967057577"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2beb74e61904dd631d9dfc8e43ae710572041e93058d759b77c37b20c6a9a431"
    sha256 cellar: :any,                 arm64_sequoia: "ee8314ce01c48102e3f977540d6095a444ceb8bce71f1868199c47cad4ce12e4"
    sha256 cellar: :any,                 arm64_sonoma:  "57899a223aa26a32842ddf3a76c4b2c3a8473ddb3537fec7ee07db54812d0425"
    sha256 cellar: :any,                 arm64_ventura: "95caade5b153801f19564ba0ea9fbf093b0881ee44a6c68c87b834ea9b3e341b"
    sha256 cellar: :any,                 sonoma:        "354ba1f7b397e045e605cec5fc47abee64523b66b93e1cf7bab14e7aa92886f2"
    sha256 cellar: :any,                 ventura:       "3dcc05ade0f1a0269b03a6d8725ba8e7bf94d2366727ac270fb84d40160ea1eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca819fe840f4ca92cf5fd514a1617215da500f76051a5c26f14c261329989e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1586618acff0317dbdcc0e93f56a1a3cc8fc64ab9f59d1f4f4afbfaf4ba9581e"
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
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <zimg.h>

      int main()
      {
        zimg_image_format format;
        zimg_image_format_default(&format, ZIMG_API_VERSION);
        assert(ZIMG_MATRIX_UNSPECIFIED == format.matrix_coefficients);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lzimg", "-o", "test"
    system "./test"
  end
end
