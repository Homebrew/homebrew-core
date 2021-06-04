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
    sha256 cellar: :any, arm64_big_sur: "07e798401b8b564e0a73800dcbf7838db211fc7206e678da8f62e40c6317e284"
    sha256 cellar: :any, big_sur:       "75d0d24c05851877e7542fca80f3e254cc8c4502946a6cc09b2cfd9cab6a94ae"
    sha256 cellar: :any, catalina:      "9a9660684f30f8263a4d3502af6cc0fd6d78d088404cd4804813cf0fd6b19d13"
    sha256 cellar: :any, mojave:        "5f4883e59f5d48c351fb8c0db259dd026a0aa8c456c3ddbec349793c651f6220"
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
 
