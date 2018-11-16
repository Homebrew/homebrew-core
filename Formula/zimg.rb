class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.8.tar.gz"
  sha256 "a8f9d65c95ce6e8050d83d0417b109aabc94d2c7ba65cf2d8039840d162ad876"
  head "https://github.com/sekrit-twc/zimg.git"

  bottle do
    cellar :any
    sha256 "1c911e3adcd45e497e7e15d20b0f43f2df75118960f0edf1e37d22d998a3bf8a" => :mojave
    sha256 "711d3e70eaf501dce077e4ac22891ecfc7c68306fd4e709da4ec79c51d2d95f8" => :high_sierra
    sha256 "c512b52b106bef8eb2b1c69f805c7b9de6c4ed19998e5b4744da3fc7cffc423a" => :sierra
    sha256 "843ecb7a93be27d37175f538037a067d097c260f43272808ca1b539f9e1c9d4e" => :el_capitan
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
