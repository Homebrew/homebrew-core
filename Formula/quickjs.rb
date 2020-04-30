class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2020-04-12.tar.xz"
  sha256 "22b15f2cc910289821379dc8d314d35ef492f6d69d4419c9bcb1b2263e9d71c8"

  bottle do
    sha256 "6b58b873d191cd9fa62edee7dddc1895770b4c0bfcd8d0c1cc12bb3dcfe92060" => :catalina
    sha256 "769005f2941b87413e9bd74ec02a8fbb261e0d7e84b9ce1727165fa16c95643a" => :mojave
    sha256 "a7744927e0027cb9ff79f4f0d4b510ecb0d78ce84865ccec4f9e2e96b7ce17b0" => :high_sierra
  end

  # Fix build on macOS
  # Alredy reported to upstream https://www.freelists.org/post/quickjs-devel/Latest-version-fails-to-build-on-macOS
  patch :p0, :DATA

  def install
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="
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
--- quickjs-libc.c
+++ quickjs-libc.c
@@ -46,8 +46,10 @@
 #include <sys/ioctl.h>
 #include <sys/wait.h>
 #if defined(__APPLE__)
 typedef sig_t sighandler_t;
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron ())
 #endif
 #endif
 
 #include "cutils.h"
