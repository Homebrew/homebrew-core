class Szip < Formula
  desc "Implementation of extended-Rice lossless compression algorithm"
  homepage "https://support.hdfgroup.org/HDF5/release/obtain5.html#extlibs"
  # https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz is 403
  url "ftp://ftp.hdfgroup.org/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/szip-2.1.1.tar.gz"
  sha256 "897dda94e1d4bf88c91adeaad88c07b468b18eaf2d6125c47acac57e540904a9"

  bottle do
    cellar :any
    sha256 "6c943de437b7c14a689a18dd69885cd90c978880e11dd0874cc995c86ac3d140" => :high_sierra
    sha256 "4672a4989b84ae533a158dd001b35d37dcc48f83e819e10014b7f2d36498082f" => :sierra
    sha256 "7233abf10076a2cf358b9fcb00e5b1db55ccbb99251341842188aeb64b3c3b63" => :el_capitan
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
