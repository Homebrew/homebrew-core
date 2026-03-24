class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  license "MIT"
  head "https://github.com/facebook/redex.git", branch: "main"

  stable do
    url "https://github.com/facebook/redex/archive/refs/tags/v2025.09.18.tar.gz"
    sha256 "49be286761fb89a223a9609d58faa141e584a0c6866bf083d8408357302ee2f8"

    # Patch to fix build with Python 3.14. Remove in the next release.
    patch do
      url "https://github.com/facebook/redex/commit/b9c7d5abf922eea7e38bc6031607eb30e8482f38.patch?full_index=1"
      sha256 "6e644764d2e2b3a7b8e69c8887e738fc6c6099f5f4a3bb6738eae6fd5677da6a"
    end

    # Patch to remove stub_resource_optimizations
    patch do
      url "https://github.com/facebook/redex/commit/f2cc84464a7392fdb266136e9c0b4b37d26a0801.patch?full_index=1"
      sha256 "043f6b77e91033b64244734d92534de3aaae05b828436cd3cb19af7af1338ec4"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4290ded870843ef5a0f59274fe9242982c77542a1cbb367408151473849b21a1"
    sha256 cellar: :any,                 arm64_sequoia: "c894e5072ff2ebbdd21b9bcecf12d5468f6e2c1e51fe27d2d5a2ee83480b5301"
    sha256 cellar: :any,                 arm64_sonoma:  "8b739a35ed027e227bcc48ea375d6c0d7a8c7a20888a8319f828993b34a68107"
    sha256 cellar: :any,                 sonoma:        "c2eca79d391a44a6645c4d0cd17982c07316a49f20a4f3ff0b3bf5190936014b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "576c939a85047bae7e36eb7821407eb2046eb746069b4b8e5a13635837338799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a31fbf584c6f289032c1d257dc26cefb218e744ff934e0d5a99c3c48c229ff"
  end

  depends_on "cmake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  # Patch FindZlib.cmake to handle macOS SDK zlib via ZLIB_HOME.
  patch :DATA

  def install
    zlib_home = if OS.linux?
      Formula["zlib-ng-compat"].opt_prefix
    else
      MacOS.sdk_for_formula(self).path/"usr"
    end

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    python_scripts = %w[
      apkutil
      redex.py
      gen_packed_apilevels.py
      tools/python/dex.py
      tools/python/dict_utils.py
      tools/python/file_extract.py
      tools/python/reach_graph.py
      tools/redex-tool/DexSqlQuery.py
      tools/redexdump-apk
    ]
    args = %W[
      -DBUILD_TYPE=Shared
      -DENABLE_STATIC=OFF
      -DZLIB_HOME=#{zlib_home}
    ]

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *python_scripts

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin/"pyredex"
    libexec.install bin/"generated_apilevels.py"
    libexec.install bin/"redex.py"

    chmod "+x", [libexec/"redex.py", libexec/"generated_apilevels.py"]

    rm bin/"redex" if (bin/"redex").exist?
    (bin/"redex").write <<~SH
      #!/bin/bash
      exec "#{libexec/"redex.py"}"  "--redex-binary" "#{bin/"redex-all"}" "$@"
    SH
    chmod "+x", bin/"redex"
  end

  test do
    resource "homebrew-test_apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    (testpath/"homebrew-default.config").write <<~JSON
      {
        "redex": {
          "passes": [
            "ReBindRefsPass",
            "ResultPropagationPass",
            "BridgeSynthInlinePass",
            "FinalInlinePassV2",
            "DelSuperPass",
            "CommonSubexpressionEliminationPass",
            "MethodInlinePass",
            "PeepholePass",
            "ConstantPropagationPass",
            "LocalDcePass",
            "RemoveUnreachablePass",
            "DedupBlocksPass",
            "UpCodeMotionPass",
            "SingleImplPass",
            "ReorderInterfacesDeclPass",
            "ShortenSrcStringsPass",
            "CommonSubexpressionEliminationPass",
            "RegAllocPass",
            "CopyPropagationPass",
            "LocalDcePass",
            "ReduceGotosPass"
          ]
        },
        "compute_xml_reachability": false,
        "analyze_native_lib_reachability": false
      }
    JSON
    (testpath/"homebrew-default.pro").write "-keep class * { *; }\n"

    testpath.install resource("homebrew-test_apk")
    config = %W[
      --config #{testpath}/homebrew-default.config
      --proguard-config #{testpath}/homebrew-default.pro
    ]
    system bin/"redex", *config, "-u", "--ignore-zipalign", "--unpack-dest", "redex-test", "redex-test.apk"
    assert_path_exists testpath/"redex-test.redex_extracted_apk"
    assert_path_exists testpath/"redex-test.redex_dexen"
  end
end

__END__
diff --git a/cmake_modules/FindZlib.cmake b/cmake_modules/FindZlib.cmake
index e3c22d8..c99d423 100644
--- a/cmake_modules/FindZlib.cmake
+++ b/cmake_modules/FindZlib.cmake
@@ -49,5 +49,5 @@ if ( _zlib_roots )
         PATHS ${_zlib_roots} NO_DEFAULT_PATH
         PATH_SUFFIXES "include" )
-    find_library( ZLIB_LIBRARIES NAMES libz.a libz.so zlib
+    find_library( ZLIB_LIBRARIES NAMES libz.a libz.so zlib z libz.tbd
         PATHS ${_zlib_roots} NO_DEFAULT_PATH
         PATH_SUFFIXES "lib" )
@@ -71,6 +71,14 @@ if (ZLIB_INCLUDE_DIR AND (PARQUET_MINIMAL_DEPENDENCY OR ZLIB_LIBRARIES))
   endif()
   set(ZLIB_STATIC_LIB ${ZLIB_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${ZLIB_LIB_NAME}${ZLIB_MSVC_STATIC_LIB_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
   set(ZLIB_SHARED_LIB ${ZLIB_LIBS}/${CMAKE_SHARED_LIBRARY_PREFIX}${ZLIB_LIB_NAME}${ZLIB_MSVC_SHARED_LIB_SUFFIX}${CMAKE_SHARED_LIBRARY_SUFFIX})
+  # On macOS SDKs, zlib may resolve to libz.tbd. Fall back to the located path
+  # when synthesized static/shared filenames do not exist.
+  if (NOT EXISTS "${ZLIB_STATIC_LIB}" AND EXISTS "${ZLIB_LIBRARIES}")
+    set(ZLIB_STATIC_LIB ${ZLIB_LIBRARIES})
+  endif()
+  if (NOT EXISTS "${ZLIB_SHARED_LIB}" AND EXISTS "${ZLIB_LIBRARIES}")
+    set(ZLIB_SHARED_LIB ${ZLIB_LIBRARIES})
+  endif()
 else ()
   set(ZLIB_FOUND FALSE)
 endif ()
