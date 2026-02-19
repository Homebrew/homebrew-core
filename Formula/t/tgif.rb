class Tgif < Formula
  desc "Xlib-based interactive 2D drawing tool"
  homepage "https://sourceforge.net/projects/tgif/"
  url "https://downloads.sourceforge.net/project/tgif/tgif/4.2.5/tgif-QPL-4.2.5.tar.gz"
  sha256 "2f24e9fecafae6e671739bd80691a06c9d032bdd1973ca164823e72ab1c567ba"
  license "QPL-1.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ba92789379368bb14652f941fc7381ef677fc5bd0b6dea2232d9b85dd4df22b4"
    sha256 arm64_sequoia: "e16a6b3637b10969037815ca5ef81f56259eeca43f92c033f089c52a72caa8c8"
    sha256 arm64_sonoma:  "93858fbcefcdcd39a3ed95339305109d26694d195948cfa04ac148e23deddcaa"
    sha256 sonoma:        "c79d27017a0486db3a1692e69327ef73776236a97d2bf60d4538f9e8499ef969"
    sha256 arm64_linux:   "1ee763ee877d11815044afc3074b8fc732034e1cfd21f0df361463099cc485a9"
    sha256 x86_64_linux:  "212c0490a0803881d8206c697ec41e7b11b9da6cf564c97d5915df75f2430e2e"
  end

  depends_on "libice"
  depends_on "libidn"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # patch sent upstream to the author email (bill.cheng@usc.edu)
  # fixes the -Wimplicit-function-declaration error on Sonoma
  patch :DATA

  def install
    # Workaround for newer Clang
    inreplace "Makefile.in", "-Wall", "-Wall -Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.obj").write <<~EOS
      %TGIF 4.2.5
      state(0,37,100.000,0,0,0,16,1,9,1,1,0,0,1,0,1,0,'Courier',0,80640,0,0,0,10,0,0,1,1,0,16,0,0,1,1,1,1,1088,1408,1,0,2880,0).
      %
      % @(#)$Header$
      % %W%
      %
      unit("1 pixel/pixel").
      color_info(11,65535,0,[
        "magenta", 65535, 0, 65535, 65535, 0, 65535, 1,
        "red", 65535, 0, 0, 65535, 0, 0, 1,
        "green", 0, 65535, 0, 0, 65535, 0, 1,
        "blue", 0, 0, 65535, 0, 0, 65535, 1,
        "yellow", 65535, 65535, 0, 65535, 65535, 0, 1,
        "pink", 65535, 49344, 52171, 65535, 49344, 52171, 1,
        "cyan", 0, 65535, 65535, 0, 65535, 65535, 1,
        "CadetBlue", 24415, 40606, 41120, 24415, 40606, 41120, 1,
        "white", 65535, 65535, 65535, 65535, 65535, 65535, 1,
        "black", 0, 0, 0, 0, 0, 0, 1,
        "DarkSlateGray", 12079, 20303, 20303, 12079, 20303, 20303, 1
      ]).
      script_frac("0.6").
      fg_bg_colors('black','white').
      dont_reencode("FFDingbests:ZapfDingbats").
      objshadow_info('#c0c0c0',2,2).
      rotate_pivot(0,0,0,0).
      spline_tightness(1).
      page(1,"",1,'').
      box('black','',64,64,128,128,0,1,1,0,0,0,0,0,0,'1',0,[
      ]).

    EOS
    system bin/"tgif", "-print", "-text", "-quiet", "test.obj"
    assert_path_exists testpath/"test.txt"
  end
end
__END__
--- a/wb.c
+++ b/wb.c
@@ -20,11 +20,12 @@
 
 #define _INCLUDE_FROM_WB_C_
 
+#include "tgifdefs.h"
+
 #if (defined(PTHREAD) || defined(HAVE_LIBPTHREAD))
 #include <pthread.h>
 #endif /* (defined(PTHREAD) || defined(HAVE_LIBPTHREAD)) */
 
-#include "tgifdefs.h"
 #include "cmdids.h"
 
 #ifdef _HAS_STREAMS_SUPPORT
