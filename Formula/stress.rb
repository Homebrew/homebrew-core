class Stress < Formula
  desc "Tool to impose load on and stress test a computer system"
  homepage "https://github.com/resurrecting-open-source-projects/stress"
  url "https://github.com/resurrecting-open-source-projects/stress/archive/refs/tags/1.0.6.tar.gz"
  sha256 "480e879cd7d9a835eca7c145949f3e5c5dd644e503ab2bf6309cae7672b2fa68"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "682417d0cce887de4bfad5dbf1382917cda827e21b760f890a74d1856e45915d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d62a404e264f4d64f2e5a14c9adee3f6cdb3593c31880410d24f38accea32bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dc5c125c3eb8cf95cb21bf4ae2efaf114b9b47677747026ba92a5c9eb09ad6e"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4131cee3e5082600056d0872a4a0147d477c6b87f24fab295a86201a649973"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a4929d6031c9cdf21cb81c8b3ff06b3a9bad924194eeadba7996aabb9cd9a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "00d9ed736381a3967b8eaf0b709328ccb0263640fdc856fe5c2e8f2164ea705d"
    sha256 cellar: :any_skip_relocation, catalina:       "2fb692ddaa54337dfe07eb71ee647e167bbe41db054556c32d7507cba38caa43"
    sha256 cellar: :any_skip_relocation, mojave:         "6220e38d281aa1f7933c582711083d2e33bc36071e32776a55a6c8441e3de209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b303854895396f0b6b5a75e654b5315ae4eccd5d4c7de451d7d1997edb0a7e7a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix build on macOS, remove in next release
  # upstream patch, https://github.com/vbendel/stress/commit/7ae7ebe50f389054f5a78873867b5eef92b8cf97
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index d9de2ee..7679930 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,7 +10,7 @@ AC_PROG_INSTALL
 AC_PROG_MAKE_SET

 # Checks for header files.
-AC_CHECK_HEADERS([stdlib.h string.h unistd.h])
+AC_CHECK_HEADERS([stdlib.h string.h unistd.h sys/prctl.h])

 # Checks for library functions.
 AC_FUNC_FORK
diff --git a/src/stress.c b/src/stress.c
index 7cf3583..74888e5 100644
--- a/src/stress.c
+++ b/src/stress.c
@@ -29,10 +29,13 @@
 #include <signal.h>
 #include <time.h>
 #include <unistd.h>
-#include <sys/prctl.h>
 #include <sys/wait.h>
 #include "config.h"

+#ifdef HAVE_SYS_PRCTL_H
+  #include <sys/prctl.h>
+#endif
+
 /* By default, print all messages of severity info and above.  */
 static int global_debug = 2;

@@ -71,6 +74,7 @@ int usage (int status);
 int version (int status);
 long long atoll_s (const char *nptr);
 long long atoll_b (const char *nptr);
+void worker_init(void);

 /* Prototypes for worker functions.  */
 int hogcpu (void);
@@ -298,8 +302,7 @@ main (int argc, char **argv)
             switch (pid = fork ())
             {
             case 0:            /* child */
-                if (prctl(PR_SET_PDEATHSIG, SIGTERM) == -1)
-                    exit(0);
+                worker_init();
                 alarm (timeout);
                 usleep (backoff);
                 if (do_dryrun)
@@ -321,8 +324,7 @@ main (int argc, char **argv)
             switch (pid = fork ())
             {
             case 0:            /* child */
-                if (prctl(PR_SET_PDEATHSIG, SIGTERM) == -1)
-                    exit(0);
+                worker_init();
                 alarm (timeout);
                 usleep (backoff);
                 if (do_dryrun)
@@ -343,14 +345,12 @@ main (int argc, char **argv)
             switch (pid = fork ())
             {
             case 0:            /* child */
-                if (prctl(PR_SET_PDEATHSIG, SIGTERM) == -1)
-                    exit(0);
+                worker_init();
                 alarm (timeout);
                 usleep (backoff);
                 if (do_dryrun)
                     exit (0);
-                exit (hogvm
-                      (do_vm_bytes, do_vm_stride, do_vm_hang, do_vm_keep));
+                exit (hogvm (do_vm_bytes, do_vm_stride, do_vm_hang, do_vm_keep));
             case -1:           /* error */
                 err (stderr, "fork failed: %s\n", strerror (errno));
                 break;
@@ -366,8 +366,7 @@ main (int argc, char **argv)
             switch (pid = fork ())
             {
             case 0:            /* child */
-                if (prctl(PR_SET_PDEATHSIG, SIGTERM) == -1)
-                    exit(0);
+                worker_init();
                 alarm (timeout);
                 usleep (backoff);
                 if (do_dryrun)
@@ -469,6 +468,15 @@ main (int argc, char **argv)
     exit (retval);
 }

+
+void worker_init(void)
+{
+#ifdef HAVE_SYS_PRCTL_H
+  if (prctl(PR_SET_PDEATHSIG, SIGTERM) == -1)
+    exit(0);
+#endif
+}
+
 int
 hogcpu (void)
 {
