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

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b81b8c12801895e02f291fcd962c03faa8c5c550f8f3912ad189e71a950e512"
    sha256 cellar: :any,                 arm64_monterey: "d205593b6f2b24d41406f720f81fe527a985fcee83fdfb8851eb607636a7de55"
    sha256 cellar: :any,                 arm64_big_sur:  "8c12953cef25c007e23110a5c80e1a685cef585fb0696a2e31f8492894cf127a"
    sha256 cellar: :any,                 ventura:        "e04fc4dbfc4c8ddeeb36f9ff9909f06e54487635c2049884523b47093fbffb02"
    sha256 cellar: :any,                 monterey:       "47f55734407ee86c9eca1740751bf822f239151c8f119d26883f27f109380030"
    sha256 cellar: :any,                 big_sur:        "cba42f4c7903e6a9c817cab231c2a553cb3ef5e9df4c11ee4c1402a1c3e82dc1"
    sha256 cellar: :any,                 catalina:       "d64a17a417984662cb80caf048ba2898ccf432da49d9e160c4a3aca47dc01ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6accb435728be7238acce06e9235ac713b796025055e03bc0aadb28dc21f6546"
  end

  depends_on "jpeg-turbo"

  uses_from_macos "zlib"

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
      args << "ZLIB_INCLUDE=-I#{Formula["zlib"].opt_include}"
      args << "ZLIB_LIB=-L#{Formula["zlib"].opt_lib} -lz"
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
