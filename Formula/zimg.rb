class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.6.2.tar.gz"
  sha256 "db407144b265c1587867e00108f6fc810d40cf94be697de75985a0cb9041313d"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "e0c38c2c76695a96f22dc90dfa72f2a08171e75c46e95afb4595281126c0dfb9" => :high_sierra
    sha256 "cb6afa024cc80d3a0305a036d43b1b9d460ae0fc259366545c703478051b7eee" => :sierra
    sha256 "2deb0dd71a19cb7934802bbbac885b632a4694c4b637d92d68efd4afab8e39e7" => :el_capitan
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
