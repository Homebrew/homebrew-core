class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "http://zbar.sourceforge.net"
  url "https://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2"
  sha256 "234efb39dbbe5cef4189cc76f37afbe3cfcfb45ae52493bfe8e191318bdbadc6"
  revision 1

  bottle do
    cellar :any
    sha256 "fe51e5b5668ba04ba18186a7f3f78267a9a4c8270ae4c25331e3963b8002b6b0" => :sierra
    sha256 "41950a6ec2dc5631fba19098d644f9eed2b91b8be0a1a1473f6d93e796345bea" => :el_capitan
    sha256 "175d9360172bc0afc153dc1e2b3e042d3d4ad27db94ed28573c12f4c77616b74" => :yosemite
    sha256 "39865fe54a7bd3f0153e19729d0b958bd3ac5a5bac5d39a50194b39db2503317" => :mavericks
  end

  depends_on :x11 => :optional
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "imagemagick"
  depends_on "ufraw"
  depends_on "xz"
  depends_on "freetype"
  depends_on "libtool" => :run

  # Fix JPEG handling using patch from
  # https://sourceforge.net/p/zbar/discussion/664596/thread/58b8d79b#8f67
  # already applied upstream but not present in the 0.10 release
  patch :DATA

  def install
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
