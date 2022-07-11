class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec/archive/refs/tags/v4.0.tar.gz"
  sha256 "b26c2f71556dc4919714899eccdf82d2fefa5e0b3bc0125af664ec60ddc87023"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1" => :build
  depends_on xcode: :build
  depends_on macos: :mojave
  depends_on "python@3.10"

  patch :DATA

  def install
    inreplace "cmake/options.cmake", "set_if_at_least_one_set(RETDEC_ENABLE_OPENSLL
		RETDEC_ENABLE_CRYPTO)", ""
    inreplace "deps/CMakeLists.txt", "cond_add_subdirectory(openssl RETDEC_ENABLE_OPENSLL)", ""
    inreplace "src/crypto/CMakeLists.txt", "ALIAS crypto)", "ALIAS crypto)

    find_package(OpenSSL 1.1.1 REQUIRED)"
    inreplace "src/crypto/CMakeLists.txt", "retdec::deps::openssl-crypto", "OpenSSL::Crypto"
    inreplace "src/crypto/retdec-crypto-config.cmake", "openssl-crypto", ""

    openssl = Formula["openssl@1.1"]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DOPENSSL_ROOT_DIR=#{openssl.opt_prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "##### Done!", shell_output("#{bin}/retdec-decompiler.py #{test_fixtures("mach/a.out")}")
  end
end
__END__
diff --git a/deps/yara/patch.cmake b/deps/yara/patch.cmake
index 30257dce..ff8500e0 100644
--- a/deps/yara/patch.cmake
+++ b/deps/yara/patch.cmake
@@ -1,3 +1,30 @@
+# https://github.com/VirusTotal/yara/pull/1540
+function(patch_configure_ac file)
+    file(READ "${file}" content)
+    set(new_content "${content}")
+
+    string(REPLACE
+        "PKG_CHECK_MODULES(PROTOBUF_C, libprotobuf-c >= 1.0.0)"
+        "PKG_CHECK_MODULES([PROTOBUF_C], [libprotobuf-c >= 1.0.0])"
+        new_content
+        "${new_content}"
+    )
+
+    string(REPLACE
+        "AC_CHECK_LIB(protobuf-c, protobuf_c_message_unpack,,"
+        "AC_CHECK_LIB([protobuf-c], protobuf_c_message_unpack,,"
+        new_content
+        "${new_content}"
+    )
+
+    if("${new_content}" STREQUAL "${content}")
+        message(STATUS "-- Patching: ${file} skipped")
+    else()
+        message(STATUS "-- Patching: ${file} patched")
+        file(WRITE "${file}" "${new_content}")
+    endif()
+endfunction()
+patch_configure_ac("${yara_path}/configure.ac")
 
 function(patch_vcxproj file)
