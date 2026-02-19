class Vncsnapshot < Formula
  desc "Command-line utility for taking VNC snapshots"
  homepage "https://sourceforge.net/projects/vncsnapshot/"
  url "https://downloads.sourceforge.net/project/vncsnapshot/vncsnapshot/1.2a/vncsnapshot-1.2a-src.tar.gz"
  sha256 "20f5bdf6939a0454bc3b41e87e41a5f247d7efd1445f4fac360e271ddbea14ee"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/vncsnapshot[._-]v?(\d+(?:\.\d+)+[a-z]?)-src\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cdc55184ba7f8d8bf9c418d2f76e64a0a58e53e99d6bc9cf0e1859c671e7879d"
    sha256 cellar: :any,                 arm64_sequoia: "09203a37167b3df2545c21b0f7b9afe38c4de502df98ed1b7fda849f03fabd03"
    sha256 cellar: :any,                 arm64_sonoma:  "a59056be84dbc799df58848a57d128a314648b607e1a592dc1dc3d1e4ad3346e"
    sha256 cellar: :any,                 sonoma:        "b1e90c81cca208e37ed22a280346fc29aa50af24c816ace37a2dd16bc2e4fa39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53c67a5e9fe1c779d602da06f27f67d1b2e4ea041aaaafad4fbb619f2f6b85e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459ee8dd2f28c227d911c6ca369fc93846332434f4cce220c8fb2f1adc89a582"
  end

  depends_on "jpeg-turbo"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch :DATA # remove old PPC __APPLE__ ifdef from sockets.cxx

  def install
    # From Ubuntu
    inreplace "rfb.h", "typedef unsigned long CARD32;",
                       "typedef unsigned int CARD32;"

    args = [
      "JPEG_INCLUDE=-I#{Formula["jpeg-turbo"].opt_include}",
      "JPEG_LIB=-L#{Formula["jpeg-turbo"].opt_lib} -ljpeg",
    ]
    if OS.linux?
      args << "ZLIB_INCLUDE=-I#{Formula["zlib-ng-compat"].opt_include}"
      args << "ZLIB_LIB=-L#{Formula["zlib-ng-compat"].opt_lib} -lz"
    end

    ENV.deparallelize
    system "make", *args
    bin.install "vncsnapshot", "vncpasswd"
    man1.install "vncsnapshot.man1" => "vncsnapshot.1"
  end
end

__END__
diff --git a/sockets.cxx b/sockets.cxx
index ecdf0db..6c827fa 100644
--- a/sockets.cxx
+++ b/sockets.cxx
@@ -38,9 +38,9 @@ typedef int socklen_t;
 #include <fcntl.h>
 #endif

-#ifdef __APPLE__
-typedef int socklen_t;
-#endif
+//#ifdef __APPLE__
+//typedef int socklen_t;
+//#endif

 extern "C" {
 #include "vncsnapshot.h"
