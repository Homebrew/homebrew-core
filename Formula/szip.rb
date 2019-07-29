class Szip < Formula
  desc "Implementation of extended-Rice lossless compression algorithm"
  homepage "https://support.hdfgroup.org/HDF5/release/obtain5.html#extlibs"
  url "https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz"
  sha256 "21ee958b4f2d4be2c9cabfa5e1a94877043609ce86fde5f286f105f7ff84d412"
  revision 1

  bottle do
    cellar :any
    sha256 "a6f7b3c066968d98311e0a1af58464562d586f0194f29d78d9ddbee59c96b833" => :mojave
    sha256 "3b84fc3869965a5851cd13554ab46283a13adfa568ca7df1288728b2cfde0c4a" => :high_sierra
    sha256 "c57296964a6ac43991c5f3a6b0b14e3deb99e14f3d1214427385dc4112e803af" => :sierra
    sha256 "a4b1f903019aaa2e1d53e661aaf90f0e91937b3ad4b71126483feffb4c2d2e13" => :el_capitan
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
