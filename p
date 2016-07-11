index 30c3c8b..5976221 100644
--- a/Formula/fabio.rb
+++ b/Formula/fabio.rb
@@ -23,9 +23,8 @@ class Fabio < Formula
     ln_s buildpath, buildpath/"src/github.com/eBay/fabio"

     ENV["GOPATH"] = buildpath.to_s
-    ENV["GO15VENDOREXPERIMENT"] = "1"

-    system "go", "install", "-tags", "netgo", "github.com/eBay/fabio"
+    system "go", "install", "github.com/eBay/fabio"
     bin.install "#{buildpath}/bin/fabio"
   end
