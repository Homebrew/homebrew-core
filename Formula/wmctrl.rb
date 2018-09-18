class Wmctrl < Formula
  desc "UNIX/Linux command-line tool to interact with an EWMH/NetWM"
  homepage "https://sites.google.com/site/tstyblo/wmctrl"
  url "https://sites.google.com/site/tstyblo/wmctrl/wmctrl-1.07.tar.gz"
  sha256 "d78a1efdb62f18674298ad039c5cbdb1edb6e8e149bb3a8e3a01a4750aa3cca9"

  bottle do
    cellar :any
    sha256 "6e8a03f71ac01f44545a25687de39e859b7d540e4d150b77497f09c08a95d9b0" => :mojave
    sha256 "b799fe4295b063ef09600bd8dbd8a8da4b7a5b047221d1c3ba67da672bff8f12" => :high_sierra
    sha256 "968c76a341ff4ef21ebe8f850e4de4301adaefd8ff8402b3373c80255adecbc7" => :sierra
    sha256 "bc752b0214893066214d649b108d69b08b50729f029581b332e93780525ee204" => :el_capitan
    sha256 "0bc70cf2f7d8c90401364d8c1f9533423034941bfc375f60991c0940ae562e5b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on :x11

  # Fix for 64-bit arch. See:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=362068
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/wmctrl", "--version"
  end
end

__END__
--- wmctrl-1.07.orig/main.c
+++ wmctrl-1.07/main.c
@@ -1425,6 +1425,16 @@
      *
      * long_length = Specifies the length in 32-bit multiples of the
      *               data to be retrieved.
+     *
+     * NOTE:  see
+     * https://mail.gnome.org/archives/wm-spec-list/2003-March/msg00067.html
+     * In particular:
+     *
+     * 	When the X window system was ported to 64-bit architectures, a
+     * rather peculiar design decision was made. 32-bit quantities such
+     * as Window IDs, atoms, etc, were kept as longs in the client side
+     * APIs, even when long was changed to 64 bits.
+     *
      */
     if (XGetWindowProperty(disp, win, xa_prop_name, 0, MAX_PROPERTY_VALUE_LEN / 4, False,
             xa_prop_type, &xa_ret_type, &ret_format,
@@ -1440,7 +1450,18 @@ static gchar *get_property (Display *disp, Window win, /*{{{*/
     }

     /* null terminate the result to make string handling easier */
-    tmp_size = (ret_format / 8) * ret_nitems;
+    switch (ret_format) {
+        case 8:
+            tmp_size = sizeof(char) * ret_nitems;
+            break;
+        case 16:
+            tmp_size = sizeof(short) * ret_nitems;
+            break;
+        case 32:
+        default:
+            tmp_size = sizeof(long) * ret_nitems;
+            break;
+    }
     ret = g_malloc(tmp_size + 1);
     memcpy(ret, ret_prop, tmp_size);
     ret[tmp_size] = '\0';
