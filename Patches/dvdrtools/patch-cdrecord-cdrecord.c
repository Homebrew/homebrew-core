--- cdrecord/cdrecord.c	2005-02-06 07:55:22.000000000 +1100
+++ ../dvdrtools-0.2.1-patched/cdrecord/cdrecord.c	2005-09-15 18:30:08.000000000 +1000
@@ -2935,7 +2935,7 @@
 
 #else	/* HAVE_SYS_PRIOCNTL_H */
 
-#if defined(_POSIX_PRIORITY_SCHEDULING)
+#if defined _POSIX_PRIORITY_SCHEDULING && (_POSIX_PRIORITY_SCHEDULING -0 > 0)
 /*
  * XXX Ugly but needed because of a typo in /usr/iclude/sched.h on Linux.
  * XXX This should be removed as soon as we are sure that Linux-2.0.29 is gone.

