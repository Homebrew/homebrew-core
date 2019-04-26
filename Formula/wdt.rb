class Wdt < Formula
  desc "Transfer data as fast as possible over multiple TCP paths"
  homepage "https://www.facebook.com/WdtOpenSource"
  url "https://github.com/facebook/wdt.git", :revision => "bc22626deede683d11a2668121ebbd2d0389a7b8"
  version "1.27.1612021-145-gbc22626"
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl"

  # Patch CMakeLists to allow us to build against full folly
  patch :DATA

  def install
    args = %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
      -DWDT_USE_SYSTEM_FOLLY=On
    ]

    mktemp do
      mkdir "wdt"
      cp_r Dir["#{buildpath}/."], "wdt"

      system "cmake", buildpath, *(std_cmake_args + args)
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "wdt/Wdt.h"
      using namespace facebook::wdt;
      int main() {
        Wdt &wdt = Wdt::initializeWdt("brewtest");
        Wdt::releaseWdt("brewtest");
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{Formula["openssl"].opt_include}", "-L#{lib}",
           "-lwdt", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 04f6efb..7b02a17 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -39,6 +39,7 @@ set(BUILD_SHARED_LIBS on CACHE Bool "build shared libs")
 set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
 set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
 
+set(WDT_USE_SYSTEM_FOLLY Off CACHE BOOL "Use folly library from system (default off)")
 
 # Optimized by default
 # TODO: This doesn't seem to work / sets default to "" instead of Release...
@@ -51,33 +52,36 @@ set(CMAKE_CXX_FLAGS "-msse4.2 -mpclmul")
 #set(CMAKE_CXX_FLAGS "-msse4.2 -mpclmul -Wextra -Wsign-compare -Wunused-variable -Wconversion -Wsign-conversion")
 set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "_bin/wdt")
 
-# Check that we have the Folly source tree
-set(FOLLY_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../folly" CACHE path
-    "Folly source tree (folly/Conv.h should be reachable from there")
-# Check for folly - TODO: this doesn't work well for relative paths
-# (because of relative to build dir vs relative to source tree for -I)
-if(NOT EXISTS "${FOLLY_SOURCE_DIR}/folly/Conv.h")
-  MESSAGE(FATAL_ERROR "${FOLLY_SOURCE_DIR}/folly/Conv.h not found
-Fix using:
-(in a sister directory of the wdt source tree - same level:)
-git clone https://github.com/facebook/folly.git
-or change FOLLY_SOURCE_DIR (use ccmake or -DFOLLY_SOURCE_DIR=...)
-")
+if (NOT WDT_USE_SYSTEM_FOLLY)
+  # Check that we have the Folly source tree
+  set(FOLLY_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../folly" CACHE path
+      "Folly source tree (folly/Conv.h should be reachable from there")
+  # Check for folly - TODO: this doesn't work well for relative paths
+  # (because of relative to build dir vs relative to source tree for -I)
+  if(NOT EXISTS "${FOLLY_SOURCE_DIR}/folly/Conv.h")
+    MESSAGE(FATAL_ERROR "${FOLLY_SOURCE_DIR}/folly/Conv.h not found
+  Fix using:
+  (in a sister directory of the wdt source tree - same level:)
+  git clone https://github.com/facebook/folly.git
+  or change FOLLY_SOURCE_DIR (use ccmake or -DFOLLY_SOURCE_DIR=...)
+  or change WDT_USE_SYSTEM_FOLLY (use ccmake or -DWDT_USE_SYSTEM_FOLLY=...)
+  ")
+  endif()
+
+
+  # The part of folly that isn't pure .h and we use:
+  set (FOLLY_CPP_SRC
+  "${FOLLY_SOURCE_DIR}/folly/Conv.cpp"
+  "${FOLLY_SOURCE_DIR}/folly/Demangle.cpp"
+  "${FOLLY_SOURCE_DIR}/folly/hash/Checksum.cpp"
+  "${FOLLY_SOURCE_DIR}/folly/hash/detail/ChecksumDetail.cpp"
+  "${FOLLY_SOURCE_DIR}/folly/hash/detail/Crc32cDetail.cpp"
+  "${FOLLY_SOURCE_DIR}/folly/hash/detail/Crc32CombineDetail.cpp"
+  "${FOLLY_SOURCE_DIR}/folly/lang/ColdClass.cpp"
+  "${FOLLY_SOURCE_DIR}/folly/ScopeGuard.cpp"
+  )
 endif()
 
-
-# The part of folly that isn't pure .h and we use:
-set (FOLLY_CPP_SRC
-"${FOLLY_SOURCE_DIR}/folly/Conv.cpp"
-"${FOLLY_SOURCE_DIR}/folly/Demangle.cpp"
-"${FOLLY_SOURCE_DIR}/folly/hash/Checksum.cpp"
-"${FOLLY_SOURCE_DIR}/folly/hash/detail/ChecksumDetail.cpp"
-"${FOLLY_SOURCE_DIR}/folly/hash/detail/Crc32cDetail.cpp"
-"${FOLLY_SOURCE_DIR}/folly/hash/detail/Crc32CombineDetail.cpp"
-"${FOLLY_SOURCE_DIR}/folly/lang/ColdClass.cpp"
-"${FOLLY_SOURCE_DIR}/folly/ScopeGuard.cpp"
-)
-
 # WDT's library proper - comes from: ls -1 *.cpp | grep -iv test
 add_library(wdt_min
 util/WdtSocket.cpp
@@ -140,10 +144,18 @@ find_library(GFLAGS_LIBRARY gflags)
 # OpenSSL's crypto lib
 find_package(OpenSSL REQUIRED)
 include_directories(${OPENSSL_INCLUDE_DIR})
+# System Folly
+if (WDT_USE_SYSTEM_FOLLY)
+  find_path(FOLLY_INCLUDE_DIR folly/Conv.h)
+  find_library(FOLLY_LIBRARY folly)
+else()
+  set(FOLLY_LIBRARY folly4wdt)
+  set(FOLLY_INCLUDE_DIR ${FOLLY_SOURCE_DIR})
+endif()
 
 # You can also add jemalloc to the list if you have it/want it
 target_link_libraries(wdt_min
-  folly4wdt
+  ${FOLLY_LIBRARY}
   ${GLOG_LIBRARY}
   ${GFLAGS_LIBRARY}
   ${Boost_LIBRARIES}
@@ -194,19 +206,21 @@ configure_file(build/folly-config.h.in folly/folly-config.h)
 # Wdt's config/version
 configure_file(WdtConfig.h.in wdt/WdtConfig.h)
 
-# Malloc stuff  tied to not supporting weaksympbols
-if (NOT FOLLY_HAVE_WEAK_SYMBOLS)
-  list(APPEND FOLLY_CPP_SRC "${FOLLY_SOURCE_DIR}/folly/memory/detail/MallocImpl.cpp")
-  message(STATUS "no weak symbols, adding MallocImpl to folly src")
-endif()
+if (NOT WDT_USE_SYSTEM_FOLLY)
+  # Malloc stuff  tied to not supporting weaksympbols
+  if (NOT FOLLY_HAVE_WEAK_SYMBOLS)
+    list(APPEND FOLLY_CPP_SRC "${FOLLY_SOURCE_DIR}/folly/memory/detail/MallocImpl.cpp")
+    message(STATUS "no weak symbols, adding MallocImpl to folly src")
+  endif()
 
-add_library(folly4wdt ${FOLLY_CPP_SRC})
-target_link_libraries(folly4wdt ${GLOG_LIBRARY} ${DOUBLECONV_LIBRARY})
+  add_library(folly4wdt ${FOLLY_CPP_SRC})
+  target_link_libraries(folly4wdt ${GLOG_LIBRARY} ${DOUBLECONV_LIBRARY})
+endif()
 
 # Order is important - inside fb we want the above
 # folly-config.h to be picked up instead of the fbcode one
 include_directories(${CMAKE_CURRENT_BINARY_DIR})
-include_directories(${FOLLY_SOURCE_DIR})
+include_directories(${FOLLY_INCLUDE_DIR})
 include_directories(${DOUBLECONV_INCLUDE_DIR})
 include_directories(${GLOG_INCLUDE_DIR})
 include_directories(${GFLAGS_INCLUDE_DIR})
@@ -219,12 +233,20 @@ target_link_libraries(wdtbin wdt_min)
 
 ### Install rules
 set_target_properties(wdtbin PROPERTIES RUNTIME_OUTPUT_NAME "wdt")
-install(TARGETS wdtbin wdt wdt_min folly4wdt
+install(TARGETS wdtbin wdt wdt_min
   RUNTIME DESTINATION bin
   LIBRARY DESTINATION lib
   ARCHIVE DESTINATION lib
   )
 
+if (NOT WDT_USE_SYSTEM_FOLLY)
+  install(TARGETS folly4wdt
+     RUNTIME DESTINATION bin
+     LIBRARY DESTINATION lib
+     ARCHIVE DESTINATION lib
+     )
+endif()
+
 ### Install header files
 
 # Find the . files in the root directory

