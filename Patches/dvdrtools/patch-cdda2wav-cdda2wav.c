--- cdda2wav/cdda2wav.c	2005-02-06 00:32:49.000000000 +1100
+++ ../dvdrtools-0.2.1-patched/cdda2wav/cdda2wav.c	2005-09-15 18:28:59.000000000 +1000
@@ -958,7 +958,7 @@
 	dontneedroot();
 }
 #else
-#if      defined _POSIX_PRIORITY_SCHEDULING
+#if      defined _POSIX_PRIORITY_SCHEDULING && (_POSIX_PRIORITY_SCHEDULING -0 > 0)
 #include <sched.h>
 
 static void

