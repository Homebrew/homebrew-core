--- audio_carbon.c.orig	2004-01-23 01:41:31.000000000 -0800
+++ audio_carbon.c	2009-08-24 23:07:41.000000000 -0700
@@ -94,7 +94,7 @@
 }
 
 static
-int wait(struct buffer *buffer)
+int delay(struct buffer *buffer)
 {
   if (MPWaitOnSemaphore(buffer->semaphore, kDurationForever) != noErr) {
     audio_error = _("MPWaitOnSemaphore() failed");
@@ -234,7 +234,11 @@
     break;
 
   case 16:
+#ifdef __BIG_ENDIAN__
     audio_pcm = audio_pcm_s16be;
+#else
+    audio_pcm = audio_pcm_s16le;
+#endif
     break;
   }
 
@@ -263,7 +267,7 @@
   /* wait for block to finish playing */
 
   if (buffer->pcm_nsamples == 0) {
-    if (wait(buffer) == -1)
+    if (delay(buffer) == -1)
       return -1;
 
     buffer->pcm_length = 0;
