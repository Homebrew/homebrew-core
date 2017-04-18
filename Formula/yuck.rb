class Yuck < Formula
  desc "Bog-standard command-line option parser for C"
  homepage "http://www.fresse.org/yuck/"
  url "https://github.com/hroptatyr/yuck/releases/download/v0.2.2/yuck-0.2.2.tar.xz"
  sha256 "9cd0c1af9a4afe6002f1672c8ece91d305cea1f61fbc07c7ce94a0bbe634deec"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.yuck").write("Usage: foo")
    system "#{bin}/yuck", "gen", "test.yuck"
  end

  patch :p0, :DATA
end
__END__
diff --git src/config.h.in src/config.h.in
index 5ad9fbf..25712c2 100644
--- src/config.h.in
+++ src/config.h.in
@@ -86,3 +86,5 @@

 /* m4 value used for yuck build */
 #undef YUCK_M4
+
+#define YUCK_TEMPLATE_PATH "HOMEBREW_PREFIX/Cellar/yuck/0.2.2/share/yuck"
