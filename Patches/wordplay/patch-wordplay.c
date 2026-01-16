--- wordplay.c.orig	1996-03-20 09:34:00.000000000 -0600
+++ wordplay.c	2012-10-03 05:07:15.000000000 -0500
@@ -136,13 +136,14 @@
 */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
 
 #define max(A, B) ((A) > (B) ? (A) : (B))
 #define min(A, B) ((A) < (B) ? (A) : (B))
 
-#define DEFAULT_WORD_FILE "words721.txt"
+#define DEFAULT_WORD_FILE "@PREFIX@/share/wordplay/words721.txt"
 #define WORDBLOCKSIZE 4096
 #define MAX_WORD_LENGTH 128
 #define SAFETY_ZONE MAX_WORD_LENGTH + 1
