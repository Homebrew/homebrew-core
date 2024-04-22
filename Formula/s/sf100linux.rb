class Sf100linux < Formula
  desc "Linux software for Dediprog SF100 and SF600 SPI flash programmers"
  homepage "https://github.com/DediProgSW/SF100Linux"
  url "https://github.com/DediProgSW/SF100Linux/archive/refs/tags/V1.14.20.x.tar.gz"
  sha256 "d3e710c2a4361b7a82e1fee6189e88a6a6ea149738c9cb95409f0a683e90366e"
  license "GPL-2.0-or-later"

  depends_on "libusb"
  depends_on :macos
  depends_on "pkg-config"

  patch :DATA

  def install
    system "make"
    bin.install "dpcmd"
    include.install "ChipInfoDb.dedicfg"
  end

  test do
    system "#{bin}/dpcmd", "--check"
  end
end

__END__
diff --git a/parse.c b/parse.c
index c9fe9db..462c2e8 100755
--- a/parse.c
+++ b/parse.c
@@ -19,27 +19,22 @@ FILE* openChipInfoDb(void)
 {
     FILE* fp = NULL;
     char Path[linebufsize];
+    uint32_t size = sizeof(Path);
 
     memset(Path, 0, linebufsize);
-    if (readlink("/proc/self/exe", Path, 512) != -1) {
-        dirname(Path);
+    if (_NSGetExecutablePath(Path, &size) == 0) {
+        strcpy(Path, dirname(Path));
         strcat(Path, "/ChipInfoDb.dedicfg");
-        //		printf("%s\n",Path);
         if ((fp = fopen(Path, "rt")) == NULL) {
             // ChipInfoDb.dedicfg not in program directory
-            dirname(Path);
-            dirname(Path);
-            strcat(Path, "/share/DediProg/ChipInfoDb.dedicfg");
-            //			printf("%s\n",Path);
+            strcpy(Path, dirname(Path));
+            strcpy(Path, dirname(Path));
+            strcat(Path, "/include/ChipInfoDb.dedicfg");
             if ((fp = fopen(Path, "rt")) == NULL)
                 fprintf(stderr, "Error opening file: %s\n", Path);
         }
     }
 
-    //xml_parse_result result = doc.load_file( Path );
-    //if ( result.status != xml_parse_status::status_ok )
-    //	return;
-
     return fp;
 }
