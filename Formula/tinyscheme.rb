class Tinyscheme < Formula
  desc "Very small Scheme implementation"
  homepage "http://tinyscheme.sourceforge.net"
  url "https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.40/tinyscheme-1.40.tar.gz"
  sha256 "c594c84633b1dcfe832e0416cbc9f889b6bae352845e14503883119a941a12fc"

  bottle do
    revision 1
    sha256 "fce84a2d2929ad1118015add67416e61b7d2911fbf99ab11c679aeebad6318f3" => :el_capitan
    sha256 "d23514b5d1f4c1f3360ce6773bcb2aff49986c013da608989a169149357966b4" => :yosemite
    sha256 "80d65369497ac62f490ec9818a11b8391db77382b924f67bbabc18f788fdf39e" => :mavericks
  end

  # Modify compile flags for Mac OS X per instructions
  patch :DATA

  def install
    system "make", "INITDEST=#{share}"
    lib.install("libtinyscheme.dylib")
    share.install("init.scm")
    bin.install("scheme")
  end
end

__END__
--- a/makefile  2011-01-16 20:51:17.000000000 +1300
+++ b/makefile  2012-04-08 22:38:11.000000000 +1200
@@ -21,7 +21,7 @@
 CC = gcc -fpic
 DEBUG=-g -Wall -Wno-char-subscripts -O
 Osuf=o
-SOsuf=so
+SOsuf=dylib
 LIBsuf=a
 EXE_EXT=
 LIBPREFIX=lib
@@ -34,7 +34,6 @@
 LDFLAGS = -shared
 DEBUG=-g -Wno-char-subscripts -O
 SYS_LIBS= -ldl
-PLATFORM_FEATURES= -DSUN_DL=1

 # Cygwin
 #PLATFORM_FEATURES = -DUSE_STRLWR=0
@@ -50,8 +49,7 @@
 #LIBPREFIX = lib
 #OUT = -o $@

-FEATURES = $(PLATFORM_FEATURES) -DUSE_DL=1 -DUSE_MATH=0 -DUSE_ASCII_NAMES=0
-
+FEATURES = $(PLATFORM_FEATURES) -DUSE_DL=1 -DUSE_MATH=1 -DUSE_ASCII_NAMES=0 -DOSX -DInitFile="\"$(INITDEST)/init.scm"\"
 OBJS = scheme.$(Osuf) dynload.$(Osuf)

 LIBTARGET = $(LIBPREFIX)tinyscheme.$(SOsuf)
