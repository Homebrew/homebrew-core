class Vncsnapshot < Formula
  desc "Command-line utility for taking VNC snapshots"
  homepage "https://sourceforge.net/projects/vncsnapshot/"
  url "https://downloads.sourceforge.net/project/vncsnapshot/vncsnapshot/1.2a/vncsnapshot-1.2a-src.tar.gz"
  sha256 "20f5bdf6939a0454bc3b41e87e41a5f247d7efd1445f4fac360e271ddbea14ee"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/vncsnapshot[._-]v?(\d+(?:\.\d+)+[a-z]?)-src\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "2370f7ccbd47de5982243a359f92010a2b0b5e0fbbca9d0bca0814d43a2b391f"
    sha256 cellar: :any, arm64_big_sur:  "596c1f48bea3bddbb1d63e7e35de9b91c2ec3eb369d7722e583d2ff1a99f0fcd"
    sha256 cellar: :any, monterey:       "25390ef1dff10cfc6a8cb969f1e97f6a06d04669083df34308fa1f03a6b003eb"
    sha256 cellar: :any, big_sur:        "956e584f14bf76d1b5907cd6b2063c8fe90b746e556af41976d455475ab2a727"
    sha256 cellar: :any, catalina:       "ebdef361f11059c2b912c727a4a8fee601ebd0fc9b4e36e4ef2a70f655a48983"
    sha256 cellar: :any, mojave:         "873b5911f289edac2f6af11571981a107f7ed353c281ff0e68a596f0bf77d201"
    sha256 cellar: :any, high_sierra:    "76511216d57e76f357ab805fc700f6d777db9d173436d1b65c3de0733352472b"
    sha256 cellar: :any, sierra:         "534d56ed36faf618d5617a1f32b4d7e1fd7cd433a1fc4c64e8c1e9312d53b1c9"
    sha256 cellar: :any, el_capitan:     "1069a6f396c574c9efa7f6ac41772807f3d5e53c152a94a42733d64522d0a31d"
    sha256 cellar: :any, yosemite:       "efd8f3255029bcb16a554855f3f3fdb7ea59604df888aec6380da1d7330e3094"
  end

  depends_on "jpeg"

  patch :DATA # remove old PPC __APPLE__ ifdef from sockets.cxx

  def install
    # From Ubuntu
    inreplace "rfb.h", "typedef unsigned long CARD32;",
                       "typedef unsigned int CARD32;"

    system "make"
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
