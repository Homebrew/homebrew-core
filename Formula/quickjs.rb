class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-07-21.tar.xz"
  sha256 "a906bed24c57dc9501b84a5bb4514f7eac58db82b721116ec5abe868490e53cc"

  bottle do
    sha256 "989215f264fc3240904342524457b923da278d6edd53e8fb44dad1f370b4e64f" => :mojave
    sha256 "0f472d5f083df02c3516f42c43333f09fd6e2734da64ce7a4ae027a7e4dc808f" => :high_sierra
    sha256 "3fbf3dfc902c9e68415088325ec7ec6f16e1c69204b3cd3432046d6bed14896e" => :sierra
  end

  patch :DATA

  def install
    system "make", "prefix=#{prefix}", "CONFIG_M32="
    # Tests are dependent on having a TTY, so fake it with `script`
    system "script", "-q", "/dev/stdout", "make", "test", "prefix=#{prefix}", "CONFIG_M32="
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="

    mkdir_p pkgshare

    cp_r "examples", pkgshare
    cp_r "doc", pkgshare
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match /^QJS42/, output

    path = testpath/"test.js"
    path.write "console.log('hello');"
    system "#{bin}/qjsc", path
    output = shell_output(testpath/"a.out").strip
    assert_equal "hello", output
  end
end

__END__
diff --git a/Makefile b/Makefile.patched
index 7ca93f0..dde78ff 100644
--- a/Makefile
+++ b/Makefile.patched
@@ -120,2 +120,8 @@ endif
 
+# LDFLAGS for building dynamically-loadable JS binary modules
+LDFLAGS_DYNLOAD=$(LDFLAGS)
+ifdef CONFIG_DARWIN
+LDFLAGS_DYNLOAD += -undefined dynamic_lookup
+endif
+
 PROGS=qjs$(EXE) qjsbn$(EXE) qjsc qjsbnc run-test262 run-test262-bn
@@ -370,7 +376,3 @@ doc/%.html: doc/%.texi
 
-ifndef CONFIG_DARWIN
-test: bjson.so
-endif
-
-test: qjs qjsbn
+test: qjs qjsbn bjson.so
 	./qjs tests/test_closure.js
@@ -380,5 +382,3 @@ test: qjs qjsbn
 	./qjs -m tests/test_std.js
-ifndef CONFIG_DARWIN
 	./qjs -m tests/test_bjson.js
-endif
 	./qjsbn tests/test_closure.js
@@ -460,3 +460,3 @@ bench-v8: qjs qjs32
 bjson.so: $(OBJDIR)/bjson.pic.o
-	$(CC) $(LDFLAGS) -shared -o $@ $^ $(LIBS)
+	$(CC) $(LDFLAGS_DYNLOAD) -shared -o $@ $^ $(LIBS)
 

