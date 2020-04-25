class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com"
  revision 3
  head "https://github.com/facebook/redex.git"

  stable do
    url "https://github.com/facebook/redex/archive/v2017.10.31.tar.gz"
    sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"

    # Fix compilation on High Sierra
    # Remove for next release
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "8d26d3585dd46ba830662bffcff750f5c2332b17bb2e44c642bbc91e7c768ea1" => :catalina
    sha256 "6a04f538e454dfcdcb18433ba198b2a280e566b21c74b2f881a3a8b73efa6685" => :mojave
    sha256 "a5d151af47697821120f6bca37f10eae53849fcccd397bc801d861e5fb1fbc98" => :high_sierra
    sha256 "84df4e62e4f7b2e4fe0752cbbdc65d88481f0248ea02641133b7c36535dde67c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python"

  resource "test_apk" do
    url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("test_apk").stage do
      system "#{bin}/redex", "redex-test.apk", "-o", "redex-test-out.apk"
    end
  end
end

__END__
diff --git a/libresource/RedexResources.cpp b/libresource/RedexResources.cpp
index 525601ec..a359f49f 100644
--- a/libresource/RedexResources.cpp
+++ b/libresource/RedexResources.cpp
@@ -16,6 +16,7 @@
 #include <map>
 #include <boost/regex.hpp>
 #include <sstream>
+#include <stack>
 #include <string>
 #include <unordered_set>
 #include <vector>
