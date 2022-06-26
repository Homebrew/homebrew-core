class Redex < Formula
  include Language::Python::Shebang

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com"
  license "MIT"
  revision 8
  head "https://github.com/facebook/redex.git", branch: "master"

  stable do
    url "https://github.com/facebook/redex/archive/v2017.10.31.tar.gz"
    sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"

    # Fix for automake 1.16.5
    patch do
      url "https://github.com/facebook/redex/commit/4696e1882cf88707bf7560a2994a4207a8b7c7a3.patch?full_index=1"
      sha256 "dccc41146688448ea2d99dd04d4d41fdaf7e174ae1888d3abb10eb2dfa6ed1da"
    end

    # Fix compilation on High Sierra
    # Fix boost issue (https://github.com/facebook/redex/pull/564)
    # Remove for next release
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a163d4757ff1c42ac50de19779a2b5d50c17ef4be5bc0be4c0fad6daaa267af9"
    sha256 cellar: :any,                 arm64_big_sur:  "ae66fa7a064e03be1b6547e0f922ecb192674697df74472c24f981f551c022cb"
    sha256 cellar: :any,                 monterey:       "b7cdcc65eb07f62e1483cf9ed47d2002d8bc315207f4071388444ec511dd0938"
    sha256 cellar: :any,                 big_sur:        "00629b3e7e7018c6695fe2d6a8db1c26d543662a3c30db8de461c98525076542"
    sha256 cellar: :any,                 catalina:       "9d1e529b8d4645e7d0daeedb4b16d84e9f22e14c52b91c87430e53d863688329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f1fb9e4c3b69e8f063212416c6f6b99c6b9a877bd4d8837296fbdeaf5ff0942"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.10"

  resource "test_apk" do
    url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    # https://github.com/facebook/redex/issues/457
    inreplace "Makefile.am", "/usr/include/jsoncpp", Formula["jsoncpp"].opt_include

    python_scripts = %w[
      apkutil
      redex.py
      tools/python/dex.py
      tools/python/dict_utils.py
      tools/python/file_extract.py
      tools/python/reach_graph.py
      tools/redex-tool/DexSqlQuery.py
      tools/redexdump-apk
    ]
    rewrite_shebang detected_python_shebang, *python_scripts

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("test_apk")
    system "#{bin}/redex", "--ignore-zipalign", "redex-test.apk", "-o", "redex-test-out.apk"
    assert_predicate testpath/"redex-test-out.apk", :exist?
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
diff --git a/libredex/Show.cpp b/libredex/Show.cpp
index b042070f..5e492e3f 100644
--- a/libredex/Show.cpp
+++ b/libredex/Show.cpp
@@ -9,7 +9,14 @@

 #include "Show.h"

+#include <boost/version.hpp>
+// Quoted was accepted into public components as of 1.73. The `detail`
+// header was removed in 1.74.
+#if BOOST_VERSION < 107400
 #include <boost/io/detail/quoted_manip.hpp>
+#else
+#include <boost/io/quoted.hpp>
+#endif
 #include <sstream>

 #include "ControlFlow.h"
