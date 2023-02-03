class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://github.com/VowpalWabbit/vowpal_wabbit/archive/9.7.0.tar.gz"
  sha256 "213a9386f35aa958475fa9fc54785353a8180623442eef2876867463efcfefe8"
  license "BSD-3-Clause"
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a93633d4b89c08895d347e376812dbc4949238880295cd9e40b1c7989c6a5679"
    sha256 cellar: :any,                 arm64_monterey: "94844c66dd9e1ad1926f58274857a1fa8cadfc36b8c051a11ab98fb16e1e8740"
    sha256 cellar: :any,                 arm64_big_sur:  "137e1e3cfaf566104f384a0a73cb77704872e781910ca7e18e24cc8a0f7884bd"
    sha256 cellar: :any,                 ventura:        "d6a3147090bdfa8b895db6b095407cbfbc563b2a0a3fb7fef1c84337bef95c41"
    sha256 cellar: :any,                 monterey:       "8c3fbf88dfcaff31b65606de210beb85e8000e13b63156cf1cc8281e3cc97116"
    sha256 cellar: :any,                 big_sur:        "e2f852d4573bfe2584b0d87ce178b2219943ae109633066b8e95dd8ca9a08cac"
    sha256 cellar: :any,                 catalina:       "a5150986c662a1c629d603beb83aa7b0a555d11968f0a93a1a3c35fa6ca8cf0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98957d759c485fefbe0489855bbcfcb6e2d18c788bb752fecf66747adf40b780"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "spdlog" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fmt"

  uses_from_macos "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  patch :DATA

  def install
    ENV.cxx11

    args = %w[
      -DBUILD_TESTING=OFF
      -DRAPIDJSON_SYS_DEP=ON
      -DFMT_SYS_DEP=ON
      -DSPDLOG_SYS_DEP=ON
      -DVW_BOOST_MATH_SYS_DEP=On
      -DVW_EIGEN_SYS_DEP=On
      -DVW_SSE2NEON_SYS_DEP=On
      -DVW_INSTALL=On
    ]

    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install Dir["utl/*"]
    rm bin/"active_interactor.py"
    rm bin/"vw-validate.html"
    rm bin/"clang-format.sh"
    rm bin/"release_blog_post_template.md"
    rm_r bin/"flatbuffer"
    rm_r bin/"dump_options"
  end

  test do
    (testpath/"house_dataset").write <<~EOS
      0 | price:.23 sqft:.25 age:.05 2006
      1 2 'second_house | price:.18 sqft:.15 age:.35 1976
      0 1 0.5 'third_house | price:.53 sqft:.32 age:.87 1924
    EOS
    system bin/"vw", "house_dataset", "-l", "10", "-c", "--passes", "25", "--holdout_off",
                     "--audit", "-f", "house.model", "--nn", "5"
    system bin/"vw", "-t", "-i", "house.model", "-d", "house_dataset", "-p", "house.predict"

    (testpath/"csoaa.dat").write <<~EOS
      1:1.0 a1_expect_1| a
      2:1.0 b1_expect_2| b
      3:1.0 c1_expect_3| c
      1:2.0 2:1.0 ab1_expect_2| a b
      2:1.0 3:3.0 bc1_expect_2| b c
      1:3.0 3:1.0 ac1_expect_3| a c
      2:3.0 d1_expect_2| d
    EOS
    system bin/"vw", "--csoaa", "3", "csoaa.dat", "-f", "csoaa.model"
    system bin/"vw", "-t", "-i", "csoaa.model", "-d", "csoaa.dat", "-p", "csoaa.predict"

    (testpath/"ect.dat").write <<~EOS
      1 ex1| a
      2 ex2| a b
      3 ex3| c d e
      2 ex4| b a
      1 ex5| f g
    EOS
    system bin/"vw", "--ect", "3", "-d", "ect.dat", "-f", "ect.model"
    system bin/"vw", "-t", "-i", "ect.model", "-d", "ect.dat", "-p", "ect.predict"

    (testpath/"train.dat").write <<~EOS
      1:2:0.4 | a c
        3:0.5:0.2 | b d
        4:1.2:0.5 | a b c
        2:1:0.3 | b c
        3:1.5:0.7 | a d
    EOS
    (testpath/"test.dat").write <<~EOS
      1:2 3:5 4:1:0.6 | a c d
      1:0.5 2:1:0.4 3:2 4:1.5 | c d
    EOS
    system bin/"vw", "-d", "train.dat", "--cb", "4", "-f", "cb.model"
    system bin/"vw", "-t", "-i", "cb.model", "-d", "test.dat", "-p", "cb.predict"
  end
end

__END__
diff --git a/ext_libs/ext_libs.cmake b/ext_libs/ext_libs.cmake
index 1ef57fe..20972fc 100644
--- a/ext_libs/ext_libs.cmake
+++ b/ext_libs/ext_libs.cmake
@@ -107,7 +107,7 @@ endif()
 
 add_library(sse2neon INTERFACE)
 if(VW_SSE2NEON_SYS_DEP)
-  find_path(SSE2NEON_INCLUDE_DIRS "sse2neon/sse2neon.h")
+  find_path(SSE2NEON_INCLUDE_DIRS "sse2neon.h")
   target_include_directories(sse2neon SYSTEM INTERFACE "${SSE2NEON_INCLUDE_DIRS}")
 else()
   # This submodule is placed into a nested subdirectory since it exposes its
diff --git a/vowpalwabbit/core/src/reductions/lda_core.cc b/vowpalwabbit/core/src/reductions/lda_core.cc
index f078d9c..ede5e06 100644
--- a/vowpalwabbit/core/src/reductions/lda_core.cc
+++ b/vowpalwabbit/core/src/reductions/lda_core.cc
@@ -33,7 +33,7 @@ VW_WARNING_STATE_POP
 #include "vw/io/logger.h"
 
 #if defined(__ARM_NEON)
-#  include <sse2neon/sse2neon.h>
+#  include <sse2neon.h>
 #endif
 
 #include <algorithm>
