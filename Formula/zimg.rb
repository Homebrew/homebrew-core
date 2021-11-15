class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.3.tar.gz"
  sha256 "5e002992bfe8b9d2867fdc9266dc84faca46f0bfd931acc2ae0124972b6170a7"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b7c0ee3d742c6681cf1cbb90b1a1cd3b5441a2848cbc9dd53a0d2818c8c956b"
    sha256 cellar: :any,                 arm64_big_sur:  "d08af43082dcea61fab045c0940352b810836287e9772e95af2caed2b24ee504"
    sha256 cellar: :any,                 monterey:       "043ba1e6f67e00c481e5252da3811f3f6eee860db62f24f1f236bd506a6c766d"
    sha256 cellar: :any,                 big_sur:        "ad43a31d0f773c0bb8283e80bbe5cbb81e6d310a4888a8e4f0c23dd64b173c4c"
    sha256 cellar: :any,                 catalina:       "3d51338569e7aee53eb4e3296915277290644f306443d91227ab0e76b19d9fba"
    sha256 cellar: :any,                 mojave:         "9988ced11c8fae0f4b506c1688ecacfffdd824531a150471c9694b8caf5736b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961138b475fb316e2c692afe89b957fa341eec408207ce9c950e674411d1e990"
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
