class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com"
  license "MIT"
  revision 5
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
    sha256 "38b99353ae775a8a59145ff46abffa6214e13e5069574d6f37d647b99612092b" => :catalina
    sha256 "9bfe343fbde2ce7c2f3fb1bf5429ee310c52efe5bd229dd51220542d312ee1aa" => :mojave
    sha256 "76a9a498034b150c3fd5a32b10008ce37fe92f6657c0c978a84bb04bc9b8d4b8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.8"

  resource "test_apk" do
    url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    # https://github.com/facebook/redex/issues/457
    inreplace "Makefile.am", "/usr/include/jsoncpp", Formula["jsoncpp"].opt_include

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
