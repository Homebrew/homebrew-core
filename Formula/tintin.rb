class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.11/tintin-2.02.11.tar.gz"
  sha256 "b39289ef1e26d2f5b7f7e33f70bcd894060c95dd96c157bb976f063c59a8b1f5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d83f015d20e728c68ca04c314949a31f9d5c8c036ee680bf7b928f68acc69899"
    sha256 cellar: :any, big_sur:       "d519dd8c15f67dbc1f8f2d53f5be240d3d2072be570bf8e51c230e36fc186bdf"
    sha256 cellar: :any, catalina:      "c69afb31c206f6551f1009eca62a6f57845b32a89795c5c6e56a6155c86f232b"
    sha256 cellar: :any, mojave:        "aa54bff2eec7ad5b8d4bfc7eac365156a98a84f3304516e2ba919006994dfbe9"
  end

  depends_on "gnutls"
  depends_on "pcre"

  # Fix for `error: use of undeclared identifier 'environ'`.
  # Already applied upstream.
  # https://github.com/scandum/tintin/issues/47
  patch :DATA

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end

__END__
diff --git a/src/data.c b/src/data.c
index 34401f8..cf23f58 100644
--- a/src/data.c
+++ b/src/data.c
@@ -27,6 +27,8 @@

 #include <limits.h>

+extern char **environ;
+
 struct listroot *init_list(struct session *ses, int type, int size)
 {
 	struct listroot *listhead;
diff --git a/src/scan.c b/src/scan.c
index 7c46890..b036e9f 100644
--- a/src/scan.c
+++ b/src/scan.c
@@ -33,6 +33,7 @@
   #endif
 #endif
 #include <dirent.h>
+#include <limits.h>
 
 #define DO_SCAN(scan) struct session *scan(struct session *ses, FILE *fp, char *arg, char *arg1, char *arg2)
 
