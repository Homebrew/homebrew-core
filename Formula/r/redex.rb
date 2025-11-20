class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  license "MIT"
  revision 20
  head "https://github.com/facebook/redex.git", branch: "main"

  stable do
    url "https://github.com/facebook/redex/archive/refs/tags/v2017.10.31.tar.gz"
    sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"

    # Fix for automake 1.16.5
    patch do
      url "https://github.com/facebook/redex/commit/4696e1882cf88707bf7560a2994a4207a8b7c7a3.patch?full_index=1"
      sha256 "dccc41146688448ea2d99dd04d4d41fdaf7e174ae1888d3abb10eb2dfa6ed1da"
    end

    # Apply upstream fixes for GCC 11
    patch do
      url "https://github.com/facebook/redex/commit/70a82b873da269e7dd46611c73cfcdf7f84efa1a.patch?full_index=1"
      sha256 "44ce35ca93922f59fb4d0fd1885d24cce8a08d73b509e1fd2675557948464f1d"
    end
    patch do
      url "https://github.com/facebook/redex/commit/e81dda3f26144a9c94816c12237698ef2addf864.patch?full_index=1"
      sha256 "523ad3d7841a6716ac973b467be3ea8b6b7e332089f23e4788e1f679fd6f53f5"
    end
    patch do
      url "https://github.com/facebook/redex/commit/253b77159d6783786c8814168d1ff2b783d3a531.patch?full_index=1"
      sha256 "ed69a6230506704ca4cc7a52418b3af70a6182bd96abdb5874fab02f6b1a7c99"
    end

    # Fix compilation on High Sierra
    # Fix boost issue (https://github.com/facebook/redex/pull/564)
    # Remove for next release
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ccd598d35c980d9c5220de5fa1a9bdcf3ff6c9cdd74e20f20143f7dc3dee5694"
    sha256 cellar: :any,                 arm64_sequoia: "acd97e017326b3c2a1cff2eef31078a79ea1f5a0129531c31c1b2566e70648d4"
    sha256 cellar: :any,                 arm64_sonoma:  "cd443c5e4f40643b584184041c3c6d4809bc6c7127bb64a67c169d89269029d2"
    sha256 cellar: :any,                 sonoma:        "b499a2a789dd133952eb96a2c0a3c591daa178248a352db5bf1c62cc687f492e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bfe2a1cdb1329411574b37c837686859e283dbcf22175a1a5bd9486b35b082e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1ccda8d1eb737e03a2a3e01b34b171bde12f49a896b48224e63e95af76c12f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.14"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    if build.stable?
      # https://github.com/facebook/redex/issues/457
      inreplace "Makefile.am", "/usr/include/jsoncpp", Formula["jsoncpp"].opt_include
      # Work around missing include. Fixed upstream but code has been refactored
      # Ref: https://github.com/facebook/redex/commit/3f4cde379da4657068a0dbe85c03df558854c31c
      ENV.append "CXXFLAGS", "-include set"
      # Help detect Boost::Filesystem and Boost::System during ./configure.
      # TODO: Remove in the next release.
      ENV.cxx11
    end

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

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
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *python_scripts

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-test_apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test_apk")
    system bin/"redex", "--ignore-zipalign", "redex-test.apk", "-o", "redex-test-out.apk"
    assert_path_exists testpath/"redex-test-out.apk"
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
