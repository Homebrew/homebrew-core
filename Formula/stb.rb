class Stb < Formula
  desc "Single-file public domain libraries for C/C++"
  homepage "https://github.com/nothings/stb"
  url "https://github.com/nothings/stb/archive/f67165c2bb2af3060ecae7d20d6f731173485ad0.tar.gz"
  version "2.35"
  sha256 "ad5d34b385494cf68c52fad5762d00181c0c6d4787988fc75f17295c3c726bf8"

  def install
    include.install "stb.h"
    include.install "stb_easy_font.h"
    include.install "stb_leakcheck.h"
    include.install "stb_truetype.h"
    include.install "stb_c_lexer.h"
    include.install "stb_herringbone_wang_tile.h"
    include.install "stb_perlin.h"
    include.install "stb_voxel_render.h"
    include.install "stb_connected_components.h"
    include.install "stb_image.h"
    include.install "stb_rect_pack.h"
    include.install "stretchy_buffer.h"
    include.install "stb_divide.h"
    include.install "stb_image_resize.h"
    include.install "stb_sprintf.h"
    include.install "stb_ds.h"
    include.install "stb_image_write.h"
    include.install "stb_textedit.h"
    include.install "stb_dxt.h"
    include.install "stb_tilemap_editor.h"
    include.install "stb_vorbis.c"
    # for test
    copy_entry "tests", (include/"tests")
    system "ls", (include/"tests")
  end

  test do
    copy_entry (include/"tests"), testpath
    # we need a different makefile include
    rm "Makefile"
    (testpath/"Makefile").write <<~EOS
      INCLUDES = -I#{include}
      CFLAGS = -Wno-pointer-to-int-cast -Wno-int-to-pointer-cast -DSTB_DIVIDE_TEST
      CPPFLAGS = -Wno-write-strings -DSTB_DIVIDE_TEST
      all:
      	$(CC) $(INCLUDES) $(CFLAGS) test_c_compilation.c test_c_lexer.c test_dxt.c test_easyfont.c test_image.c test_image_write.c test_perlin.c test_sprintf.c test_truetype.c test_voxel.c -lm
      	$(CC) $(INCLUDES) $(CPPFLAGS) -std=c++0x test_cpp_compilation.cpp -lm -lstdc++
      	$(CC) $(INCLUDES) $(CFLAGS) -DIWT_TEST image_write_test.c -lm -o image_write_test
    EOS
    system "make", "all"
  end
end
