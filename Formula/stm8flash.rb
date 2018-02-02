class Stm8flash < Formula
  desc "program your stm8 devices with SWIM/stlinkv(1,2)"
  homepage "https://github.com/vdudouyt/stm8flash"
  url "https://github.com/vdudouyt/stm8flash.git", :revision => "6007cb7062bb86d4c17c79174ee177e80939f602"
  version "20170616-1.1"
  patch :DATA
  depends_on "libusb"
  depends_on "pkg-config" => :build
  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "install"
  end
  test do
    system "#{bin}/stm8flash", "-V"
  end
end
__END__
diff --git a/Makefile b/Makefile
index 7fc76c3..9cb8503 100644
--- a/Makefile
+++ b/Makefile
@@ -63,6 +63,6 @@ clean:
 	-rm -f $(OBJECTS) $(BIN)$(BIN_SUFFIX)

 install:
-	mkdir -p $(DESTDIR)/usr/local/bin/
-	cp $(BIN)$(BIN_SUFFIX) $(DESTDIR)/usr/local/bin/
+	mkdir -p $(DESTDIR)/bin/
+	cp $(BIN)$(BIN_SUFFIX) $(DESTDIR)/bin/
