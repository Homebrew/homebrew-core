--- ls.c.orig	Fri Oct 15 14:20:50 2004
+++ ls.c	Fri Oct 15 14:21:13 2004
@@ -160,7 +160,7 @@
     return buf;
 }
 
-#if !defined(__FreeBSD__) && !defined(__OpenBSD__)
+#if !defined(__FreeBSD__) && !defined(__OpenBSD__) && !defined(__APPLE__)
 static void strmode(mode_t mode, char *dest)
 {
     static const char *rwx[] = {
