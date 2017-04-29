# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Srcml < Formula
  desc "srcML - an infrastructure for the exploration, analysis, and manipulation of source code"
  homepage "http://www.srcml.org/"
  url "http://131.123.42.38/lmcrs/beta/srcML-src.tar.gz"
  version "0.9.5"
  sha256 "55dd2115548e270724af4251187343656d2dfda0e7d372fee15ae27262e3fa8e"

  depends_on "cmake" => :build
  depends_on "LibArchive"
  depends_on "libxml2"

#  env do
#    unless HOMEBREW_PREFIX.to_s == "/usr/local"
#      ENV.append_path "HOMEBREW_LIBRARY_PATHS", "/usr/local/lib"
#    end
#  end

  def install
    #system "cmake", "-DINSTALL_PREFIX=/usr/local/Cellar/srcml/0.9.5", "-G", "Unix Makefiles", *std_cmake_args
    system "cmake", *std_cmake_args
    system "make", "install", "prefix=#{prefix}"
  end

  patch :DATA 

  test do
    system "true"
  end
end
__END__
diff -r -u a/CMake/config.cmake b/CMake/config.cmake
--- a/CMake/config.cmake	2015-05-20 02:36:48.000000000 +0100
+++ b/CMake/config.cmake	2017-03-31 20:07:37.000000000 +0100
@@ -44,7 +44,7 @@
 
 # Dynamic Load libraries (Unix only)
 if(NOT WIN32)
-    option(DYNAMIC_LOAD_ENABLED "Dynamically load some libraries such as libxslt and libexslt" ON)
+	option(DYNAMIC_LOAD_ENABLED "Dynamically load some libraries such as libxslt and libexslt" ON)
 endif()
 
 if(NOT DYNAMIC_LOAD_ENABLED)
@@ -89,6 +89,8 @@
 else()
 
     set(WINDOWS_DEP_PATH "")
+
+    include_directories(${LibArchive_INCLUDE_DIRS} ${LIBXML2_INCLUDE_DIR} ${CURL_INCLUDE_DIRS} ${Boost_INCLUDE_DIR})
     
     # Locating packages.
     find_package(LibArchive REQUIRED)
@@ -99,7 +101,6 @@
     find_package(Boost COMPONENTS program_options filesystem system thread regex date_time REQUIRED)
 
     # add include directories
-    include_directories(${LibArchive_INCLUDE_DIRS} ${LIBXML2_INCLUDE_DIR} ${CURL_INCLUDE_DIRS} ${Boost_INCLUDE_DIR})
 
     if(DYNAMIC_LOAD_ENABLED)
         find_package(LibXslt)
@@ -119,13 +120,16 @@
 find_library(ANTLR_LIBRARY NAMES libantlr-pic.a libantlr.a libantlr2-0.dll antlr.lib PATHS /usr/lib /usr/local/lib ${WINDOWS_DEP_PATH}/lib)
 
 if(DYNAMIC_LOAD_ENABLED)
-    set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} dl crypto pthread
+#    set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} dl crypto pthread
+    set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} dl pthread
                 CACHE INTERNAL "Libraries needed to build libsrcml")
 elseif(NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC" AND NOT WIN32)
-    set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARY} crypto pthread
+#    set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARY} crypto pthread
+	set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARY} pthread
                 CACHE INTERNAL "Libraries needed to build libsrcml")
 elseif(NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
-    set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARY} crypto pthread
+#    set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARY} crypto pthread
+	set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${Boost_LIBRARIES} ${ANTLR_LIBRARY} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARY} pthread
                 CACHE INTERNAL "Libraries needed to build libsrcml")
 else()
     set(LIBSRCML_LIBRARIES ${LIBXML2_LIBRARIES} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARY} ${Boost_LIBRARIES} ${ANTLR_LIBRARY}
@@ -138,9 +142,12 @@
 endif()
 
 if(NOT WIN32)
-    set(SRCML_LIBRARIES ${LibArchive_LIBRARIES} ${Boost_LIBRARIES} ${CURL_LIBRARIES} crypto pthread CACHE INTERNAL "Libraries needed to build srcml")
+#    set(SRCML_LIBRARIES ${LibArchive_LIBRARIES} ${Boost_LIBRARIES} ${CURL_LIBRARIES} crypto pthread CACHE INTERNAL "Libraries needed to build srcml")
+
+    set(SRCML_LIBRARIES ${LibArchive_LIBRARIES} ${Boost_LIBRARIES} ${CURL_LIBRARIES} pthread CACHE INTERNAL "Libraries needed to build srcml")
 elseif(NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
-    set(SRCML_LIBRARIES ${LibArchive_LIBRARIES} ${Boost_LIBRARIES} ${CURL_LIBRARIES} ws2_32 crypto CACHE INTERNAL "Libraries needed to build srcml")
+#    set(SRCML_LIBRARIES ${LibArchive_LIBRARIES} ${Boost_LIBRARIES} ${CURL_LIBRARIES} ws2_32 crypto CACHE INTERNAL "Libraries needed to build srcml")
+    set(SRCML_LIBRARIES ${LibArchive_LIBRARIES} ${Boost_LIBRARIES} ${CURL_LIBRARIES} ws2_32 CACHE INTERNAL "Libraries needed to build srcml")
 else()
     set(SRCML_LIBRARIES ${LibArchive_LIBRARIES} ${Boost_LIBRARIES} ${CURL_LIBRARIES} ws2_32 ${LIBSRCML_LIBRARIES} CACHE INTERNAL "Libraries needed to build srcml")
 endif()
@@ -174,7 +181,7 @@
 # The default configuration is to compile in DEBUG mode. These flags can be directly
 # overridden by setting the property of a target you wish to change them for.
 if(NOT CMAKE_BUILD_TYPE)
-    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel." FORCE)
+	set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel." FORCE)
 endif(NOT CMAKE_BUILD_TYPE)
 
 if(${CMAKE_COMPILER_IS_GNUCXX})
diff -r -u a/CMakeLists.txt b/CMakeLists.txt
--- a/CMakeLists.txt	2015-05-20 02:36:48.000000000 +0100
+++ b/CMakeLists.txt	2017-03-31 19:03:11.000000000 +0100
@@ -31,7 +31,7 @@
 set(CMAKE_MACOSX_RPATH 1)
 
 # Setting up source include directories.
-include_directories(BEFORE src/srcml src/libsrcml src/parser src/srcSAX)
+include_directories(BEFORE /usr/local/include /usr/local/opt/libxml2/include/libxml2 src/srcml src/libsrcml src/parser src/srcSAX)
 
 # Setting major and minor version numbers (TODO fix this so that it is set using something
 # more correct that being input from within the build system).
diff -r -u a/src/CMakeLists.txt b/src/CMakeLists.txt
--- a/src/CMakeLists.txt	2015-05-20 02:36:48.000000000 +0100
+++ b/src/CMakeLists.txt	2017-03-31 20:20:05.000000000 +0100
@@ -36,7 +36,7 @@
 # 
 macro(buildLib LIB_NAME LIB_TYPE)
 
-    add_library(${LIB_NAME} ${LIB_TYPE} $<TARGET_OBJECTS:parser> $<TARGET_OBJECTS:libsrcml> $<TARGET_OBJECTS:srcsax> build_hack.cpp)
+    add_library(${LIB_NAME} ${LIB_TYPE} $<TARGET_OBJECTS:parser> $<TARGET_OBJECTS:libsrcml> $<TARGET_OBJECTS:srcsax>)
 
 if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
     set_target_properties(${LIB_NAME} PROPERTIES OUTPUT_NAME libsrcml LINK_FLAGS_DEBUG "/SAFESEH:NO")
Only in a/src: build_hack.cpp
diff -r -u a/src/libsrcml/srcml_reader_handler.hpp b/src/libsrcml/srcml_reader_handler.hpp
--- a/src/libsrcml/srcml_reader_handler.hpp	2015-05-20 02:36:48.000000000 +0100
+++ b/src/libsrcml/srcml_reader_handler.hpp	2017-03-31 18:27:04.000000000 +0100
@@ -456,7 +456,7 @@
 
             if(uri == SRCML_CPP_NS_URI) {
 
-                if(archive->language != 0) {
+                if(archive->language) {
 
                     if(*archive->language == "C++" || *archive->language == "C" || *archive->language == "Objective-C")
                         archive->options |= SRCML_OPTION_CPP | SRCML_OPTION_CPP_NOMACRO;
