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
    sha256 "5929b876b1536e7b4c75ea08e52a94aafb43326bdfda8258929929a867e8f15d" => :high_sierra
    sha256 "86a824f7c99c057389d03591a665a85d975e43f7296bf2a26e8bd7664846562a" => :sierra
    sha256 "b30c6de3d4194cfe20e054cb2f3aa271766f1147da91295bf03db9c422384a7d" => :el_capitan
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
