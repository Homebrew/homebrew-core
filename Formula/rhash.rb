class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.4/rhash-1.3.4-src.tar.gz"
  sha256 "406662c4703bd4cb1caae26f32700951a5e12adf39f141d3f40e0b461b1e9e49"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha256 "24d81bee8d36e3be65981ac8ffbee6bbd0f08225d61890c2bf288dd73fa8e341" => :sierra
    sha256 "2b0a7894d2fb528879129c659a5bb50fe6c26d9c6b67ffc19d1f7462d54cf310" => :el_capitan
    sha256 "55f45a776a493178a094e3bf3d612b5720fffc33d14446ba2aac06b5be7e8358" => :yosemite
  end

  # Upstream issue: https://github.com/rhash/RHash/pull/7
  # This patch will need to be in place permanently.
  patch :DATA

  def install
    # install target isn't parallel-safe
    ENV.deparallelize

    system "make", "lib-static", "lib-shared", "all", "CC=#{ENV.cc}"
    system "make", "install-lib-static", "install-lib-shared", "install",
                   "PREFIX=", "DESTDIR=#{prefix}", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end

__END__
--- a/librhash/Makefile	2014-04-20 14:20:22.000000000 +0200
+++ b/librhash/Makefile	2014-04-20 14:40:02.000000000 +0200
@@ -26,8 +26,8 @@
 INCDIR  = $(PREFIX)/include
 LIBDIR  = $(PREFIX)/lib
 LIBRARY = librhash.a
-SONAME  = librhash.so.0
-SOLINK  = librhash.so
+SONAME  = librhash.0.dylib
+SOLINK  = librhash.dylib
 TEST_TARGET = test_hashes
 TEST_SHARED = test_shared
 # Set variables according to GNU coding standard
@@ -176,8 +176,7 @@

 # shared and static libraries
 $(SONAME): $(SOURCES)
-	sed -n '1s/.*/{ global:/p; s/^RHASH_API.* \([a-z0-9_]\+\)(.*/  \1;/p; $$s/.*/local: *; };/p' $(SO_HEADERS) > exports.sym
-	$(CC) -fpic $(ALLCFLAGS) -shared $(SOURCES) -Wl,--version-script,exports.sym,-soname,$(SONAME) $(LIBLDFLAGS) -o $@
+	$(CC) -fpic $(ALLCFLAGS) -dynamiclib $(SOURCES) $(LIBLDFLAGS) -Wl,-install_name,$(PREFIX)/lib/$@ -o $@
 	ln -s $(SONAME) $(SOLINK)
 # use 'nm -Cg --defined-only $@' to view exported symbols
