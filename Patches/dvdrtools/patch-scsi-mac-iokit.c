diff -Naur libscg/scsi-mac-iokit.c libscg-patched/scsi-mac-iokit.c
--- libscg/scsi-mac-iokit.c	Sat Feb  5 14:32:50 2005
+++ libscg-patched/scsi-mac-iokit.c	Mon Feb 14 13:48:11 2005
@@ -55,7 +55,14 @@
 #include <Carbon/Carbon.h>
 #include <IOKit/IOKitLib.h>
 #include <IOKit/IOCFPlugIn.h>
-#include <IOKit/scsi-commands/SCSITaskLib.h>
+
+/* VERSION is used as an identifier somewhere in the Apple headers. */
+#define AVOID_COLLISION_SAVE_VERSION VERSION
+#undef VERSION
+#include <IOKit/scsi/SCSITaskLib.h>
+#define VERSION AVOID_COLLISION_SAVE_VERSION
+#undef AVOID_COLLISION_SAVE_VERSION
+
 #include <mach/mach_error.h>
 
 struct scg_local {
