class Wput < Formula
  desc "Tiny, wget-like FTP client for uploading files"
  homepage "https://wput.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/wput/wput/0.6.2/wput-0.6.2.tgz"
  sha256 "229d8bb7d045ca1f54d68de23f1bc8016690dc0027a16586712594fbc7fad8c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "563c5204880172786cbbfc75dafa818e670ac5d1a67fdbe8bea1dd2588587eab" => :mojave
    sha256 "e01d35805cd00e8f4d9ba1ab989104d66dc4150648a2288f5f49eea5c17b5025" => :high_sierra
    sha256 "0a8c4296a3e14d8b420f65464293b000dd1bd2e33a802c92e1812f0c267d3f0f" => :sierra
    sha256 "8e4eeb941d98dc0313b87682b7ae659bbceac59426cf0483c2ae2676cf5b924b" => :el_capitan
    sha256 "97bc045a03ddd01106304530a453a47693fbd5f3419090310c91a187e1d23931" => :yosemite
    sha256 "3e9c649d134fff0d79d23a2eb575e440354e938b0f261c5fed53efe9d6f3f8c9" => :mavericks
  end

  # The patch is to skip inclusion of malloc.h only on OSX. Upstream:
  # https://sourceforge.net/p/wput/patches/22/
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/wput", "--version"
  end
end

__END__
diff --git a/src/memdbg.c b/src/memdbg.c
index 560bd7c..9e69eef 100644
--- a/src/memdbg.c
+++ b/src/memdbg.c
@@ -1,5 +1,7 @@
 #include <stdio.h>
+#ifndef __APPLE__
 #include <malloc.h>
+#endif
 #include <fcntl.h>
 #ifndef WIN32
 #include <sys/socket.h>
diff --git a/src/socketlib.c b/src/socketlib.c
index ab77d2b..c728ed9 100644
--- a/src/socketlib.c
+++ b/src/socketlib.c
@@ -20,7 +20,9 @@
  * It is meant to provide some library functions. The only required external depency
  * the printip function that is provided in utils.c */

+#ifndef __APPLE__
 #include <malloc.h>
+#endif
 #include <string.h>
 #include <fcntl.h>
 #include <errno.h>
