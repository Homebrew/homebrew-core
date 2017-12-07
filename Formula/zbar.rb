class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://zbar.sourceforge.io"
  revision 8

  stable do
    url "https://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2"
    sha256 "234efb39dbbe5cef4189cc76f37afbe3cfcfb45ae52493bfe8e191318bdbadc6"

    # Fix JPEG handling using patch from
    # https://sourceforge.net/p/zbar/discussion/664596/thread/58b8d79b#8f67
    # already applied upstream but not present in the 0.10 release
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "abcf91210917bbde7b317e3936177344eafb38a938b3058fece85646cba43000" => :high_sierra
    sha256 "b1d3f126b515d19d6bb1a35900c7aa9bddc36aa62b03d6f19f3c302584648ea3" => :sierra
    sha256 "eb338869d998fa094a2c1a49565405e1c3c0b6697fbe55ebf3369ea35a58834e" => :el_capitan
    sha256 "9e5ba88e909d3150b5496e2d70f8e63b63edbf918887428b3a57183da7878bf3" => :yosemite
  end

  head do
    url "https://github.com/ZBar/ZBar.git"

    depends_on "gettext" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "xmlto" => :build
  end

  depends_on :x11 => :optional
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "imagemagick"
  depends_on "ufraw"
  depends_on "xz"
  depends_on "freetype"
  depends_on "libtool" => :run

  def install
    if build.head?
      inreplace "configure.ac", "-Werror", ""
      gettext = Formula["gettext"]
      system "autoreconf", "-fvi", "-I", "#{gettext.opt_share}/aclocal"
    end

    # ImageMagick 7 compatibility
    # Reported 20 Jun 2016 https://sourceforge.net/p/zbar/support-requests/156/
    inreplace ["configure", "zbarimg/zbarimg.c"],
      "wand/MagickWand.h",
      "ImageMagick-7/MagickWand/MagickWand.h"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-python
      --without-qt
      --disable-video
      --without-gtk
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end

__END__
diff --git a/zbar/jpeg.c b/zbar/jpeg.c
index fb566f4..d1c1fb2 100644
--- a/zbar/jpeg.c
+++ b/zbar/jpeg.c
@@ -79,8 +79,15 @@ int fill_input_buffer (j_decompress_ptr cinfo)
 void skip_input_data (j_decompress_ptr cinfo,
                       long num_bytes)
 {
-    cinfo->src->next_input_byte = NULL;
-    cinfo->src->bytes_in_buffer = 0;
+    if (num_bytes > 0) {
+        if (num_bytes < cinfo->src->bytes_in_buffer) {
+            cinfo->src->next_input_byte += num_bytes;
+            cinfo->src->bytes_in_buffer -= num_bytes;
+        }
+        else {
+            fill_input_buffer(cinfo);
+        }
+    }
 }
 
 void term_source (j_decompress_ptr cinfo)
