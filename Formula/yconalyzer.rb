class Yconalyzer < Formula
  desc "TCP traffic analyzer"
  homepage "https://sourceforge.net/projects/yconalyzer/"
  url "https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2"
  sha256 "3b2bd33ffa9f6de707c91deeb32d9e9a56c51e232be5002fbed7e7a6373b4d5b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3bf190ad069a4ee9423e79415907a684320e8e776916329f46d7620274a03434" => :sierra
    sha256 "918ca6d2bca328923ec3ff6e5612e9a0336aad666e993cfb0d1bc42a99758f1c" => :el_capitan
    sha256 "e3e3fcebfdd0d25fbdad33c8f2aa13976c70ab4ff4bb81ed1fbae5cb8a7c2ffd" => :yosemite
    sha256 "c2c6d2a81a8b13515192b716bac7df7db078e986f8306d37d3b4da5a2f05ccd6" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  # Fix build issues issue on macOS 10.9/clang
  # Patch reported to upstream - https://sourceforge.net/p/yconalyzer/bugs/3/
  patch :p0, :DATA
end
__END__
--- yconalyzer.cc.orig	2014-01-12 14:15:17.000000000 +0800
+++ yconalyzer.cc	2014-01-12 14:17:49.000000000 +0800
@@ -76,19 +76,11 @@

 #include <string>

-#if __GNUC__ > 2
 #include <map>
-using namespace _GLIBCXX_STD;
+using namespace std;
 // Linux gcc-3 is not too happy with the format strings we use in BSD.
 #define KEY_FMT_STRING "%#8x%#4x"

-#else	/* We are using gnu-c <= 2 */
-
-#include <hash_map.h>
-#define KEY_FMT_STRING "%8ux%4hx"
-
-#endif
-
 static int debug = 0;
 static u_short port = 0;
 static int nbuckets;
