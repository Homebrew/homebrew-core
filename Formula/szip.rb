class Szip < Formula
  desc "Implementation of extended-Rice lossless compression algorithm"
  homepage "https://support.hdfgroup.org/HDF5/release/obtain5.html#extlibs"
  url "https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz"
  sha256 "21ee958b4f2d4be2c9cabfa5e1a94877043609ce86fde5f286f105f7ff84d412"
  revision 1

  livecheck do
    url "https://support.hdfgroup.org/ftp/lib-external/szip/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d1e43af5c723d879f5d9a94199a7b6ddf70666a34a78852e5eeedd0edd5d1f1"
    sha256 cellar: :any,                 arm64_big_sur:  "8eaede9ea04a8c106c7f166f0922a1c3907a38b88867a2c51b48f060d51aaf6d"
    sha256 cellar: :any,                 monterey:       "bb1629583319977f2cdbb0ac259fac0f2befa65fb7bf89b1cb237c577b8258cb"
    sha256 cellar: :any,                 big_sur:        "1779ec8c3312993ef7e22679df6bbcd3adce9db28d3ad98adb54650c018ed294"
    sha256 cellar: :any,                 catalina:       "e27bbc3b0a5d55b33051cb6ca509836e617b6f96361a70a187a6c8d53f2b520b"
    sha256 cellar: :any,                 mojave:         "a6f7b3c066968d98311e0a1af58464562d586f0194f29d78d9ddbee59c96b833"
    sha256 cellar: :any,                 high_sierra:    "3b84fc3869965a5851cd13554ab46283a13adfa568ca7df1288728b2cfde0c4a"
    sha256 cellar: :any,                 sierra:         "c57296964a6ac43991c5f3a6b0b14e3deb99e14f3d1214427385dc4112e803af"
    sha256 cellar: :any,                 el_capitan:     "a4b1f903019aaa2e1d53e661aaf90f0e91937b3ad4b71126483feffb4c2d2e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3487d85f941aa0fcdd567ae2801c7c147f2bb1d9cc55b1cb82bcce1eec3d9c"
  end

  conflicts_with "libaec", because: "libaec provides a replacement for szip"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdlib.h>
      #include <stdio.h>
      #include "szlib.h"

      int main()
      {
        sz_stream c_stream;
        c_stream.options_mask = 0;
        c_stream.bits_per_pixel = 8;
        c_stream.pixels_per_block = 8;
        c_stream.pixels_per_scanline = 16;
        c_stream.image_pixels = 16;
        assert(SZ_CompressInit(&c_stream) == SZ_OK);
        assert(SZ_CompressEnd(&c_stream) == SZ_OK);
        return 0;
      }
    EOS
    system ENV.cc, "-L", lib, "test.c", "-o", "test", "-lsz"
    system "./test"
  end
end
