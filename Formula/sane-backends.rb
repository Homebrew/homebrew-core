class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  stable do
    url "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
    sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"
    bottle do
      revision 1
      sha256 "e8cd147368ca911b15da016a09cb3d0b58843b5169291a75fe2a42fed7c9c887" => :el_capitan
      sha256 "006f73ab657625408f5d56ec1596498b911781164db60cc4518370b2a08686f3" => :yosemite
      sha256 "168d5dc5f38b6e568f2d757de77dc86c7b3bab1a84a50f1b30103eb9ba9bf367" => :mavericks
      sha256 "483533ac9a7d48d15350afaed266ac9472cd8c945fdd34d610253253e3c384e7" => :mountain_lion
    end
  end

  head do
    url "https://alioth.debian.org/anonscm/git/sane/sane-backends.git"
  end

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"

  # Fixes some missing headers missing error. Reported upstream
  # https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make", "install"

    # Some drivers require a lockfile
    (var+"lock/sane").mkpath
  end
end

__END__
diff --git a/backend/pieusb_buffer.c b/backend/pieusb_buffer.c
index 53bd867..23fc645 100644
--- a/backend/pieusb_buffer.c
+++ b/backend/pieusb_buffer.c
@@ -100,7 +100,13 @@
 #include <stdio.h>
 #include <fcntl.h>
 #include <sys/mman.h>
+
+#ifdef __APPLE__
+#include <machine/endian.h>
+#elif
 #include <endian.h>
+#endif
+
 
 /* When creating the release backend, make complains about unresolved external
  * le16toh, although it finds the include <endian.h> */
diff --git a/include/sane/sane.h b/include/sane/sane.h
index 5320b4a..736a9cd 100644
--- a/include/sane/sane.h
+++ b/include/sane/sane.h
@@ -20,6 +20,11 @@
 extern "C" {
 #endif
 
+#ifdef __APPLE__
+// Fixes u_long missing error
+#include <sys/types.h>
+#endif
+
 /*
  * SANE types and defines
  */
diff --git a/include/sane/sanei_backend.h b/include/sane/sanei_backend.h
index 1b5afe2..982dedc 100644
--- a/include/sane/sanei_backend.h
+++ b/include/sane/sanei_backend.h
@@ -96,7 +96,9 @@
 #  undef SIG_SETMASK
 # endif
 
+# ifndef __APPLE__
 # define sigset_t               int
+# endif
 # define sigemptyset(set)       do { *(set) = 0; } while (0)
 # define sigfillset(set)        do { *(set) = ~0; } while (0)
 # define sigaddset(set,signal)  do { *(set) |= sigmask (signal); } while (0)
diff --git a/sanei/sanei_ir.c b/sanei/sanei_ir.c
index 42e82ba..0db2c29 100644
--- a/sanei/sanei_ir.c
+++ b/sanei/sanei_ir.c
@@ -29,7 +29,13 @@
 
 #include <stdlib.h>
 #include <string.h>
+#ifdef __APPLE__ //OSX
+#include <sys/types.h>
+#include <limits.h>
+#include <float.h>
+#elif // not OSX
 #include <values.h>
+#endif
 #include <math.h>
 
 #define BACKEND_NAME sanei_ir  /* name of this module for debugging */
