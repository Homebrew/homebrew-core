class Srcml < Formula
  desc "convert source code to XML"
  homepage "http://www.srcml.org/"
  url "https://github.com/yijunyu/homebrew-fast/raw/master/src/srcml-0.9.5.tar.gz"
  sha256 "55dd2115548e270724af4251187343656d2dfda0e7d372fee15ae27262e3fa8e"

  depends_on "cmake" => :build
  depends_on "LibArchive" => :build
  depends_on "antlr@2" => :build
  depends_on "libantlr3c" => :build
  depends_on "Boost" => :build
  depends_on "libxml2"

  def install
    system "cmake", "-G", "Unix Makefiles", "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG", "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_FIND_FRAMEWORK=LAST", "-DCMAKE_VERBOSE_MAKEFILE=ON", "-Wno-dev"
    system "make", "install"
  end

  patch :DATA

  test do
    (testpath/"Hello.java").write <<-EOS

public class Hello {
    public static void main(String args[]) {
        System.out.println("Hello, world!");
    }
}
    EOS

    (testpath/"example.cc").write <<-EOS
int f(int x) {
      int result = (x / 42);
        return result;
}
    EOS

    (testpath/"Hello-result.xml").write <<-EOS
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<unit xmlns="http://www.srcML.org/srcML/src" revision="0.9.5" language="Java" filename="Hello.java">
<class><specifier>public</specifier> class <name>Hello</name> <block>{
    <function><specifier>public</specifier> <specifier>static</specifier> <type><name>void</name></type> <name>main</name><parameter_list>(<parameter><decl><type><name>String</name></type> <name><name>args</name><index>[]</index></name></decl></parameter>)</parameter_list> <block>{
        <expr_stmt><expr><call><name><name>System</name><operator>.</operator><name>out</name><operator>.</operator><name>println</name></name><argument_list>(<argument><expr><literal type="string">"Hello, world!"</literal></expr></argument>)</argument_list></call></expr>;</expr_stmt>
    }</block></function>
}</block></class>
</unit>
    EOS

    (testpath/"example-result.xml").write <<-EOS
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<unit xmlns="http://www.srcML.org/srcML/src" xmlns:cpp="http://www.srcML.org/srcML/cpp" revision="0.9.5" language="C++" filename="example.cc"><function><type><name>int</name></type> <name>f</name><parameter_list>(<parameter><decl><type><name>int</name></type> <name>x</name></decl></parameter>)</parameter_list> <block>{
      <decl_stmt><decl><type><name>int</name></type> <name>result</name> <init>= <expr><operator>(</operator><name>x</name> <operator>/</operator> <literal type="number">42</literal><operator>)</operator></expr></init></decl>;</decl_stmt>
        <return>return <expr><name>result</name></expr>;</return>
}</block></function></unit>
    EOS

    fork do
      exec "#{bin}/srcml", "example.c", "-o", "example.xml"
      exec "#{bin}/srcml", "Hello.java", "-o", "Hello.xml"
      exec "diff", "Hello.xml", "Hello-result.xml"
      exec "diff", "example.xml", "example-result.xml"
    end
  end
end
__END__
diff -r -u a/CMake/config.cmake b/CMake/config.cmake
--- a/CMake/config.cmake	2015-05-20 02:36:48.000000000 +0100
+++ b/CMake/config.cmake	2017-04-01 16:23:05.000000000 +0100
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
@@ -116,16 +117,19 @@
 endif()
 
 # Locating the antlr library.
-find_library(ANTLR_LIBRARY NAMES libantlr-pic.a libantlr.a libantlr2-0.dll antlr.lib PATHS /usr/lib /usr/local/lib ${WINDOWS_DEP_PATH}/lib)
+find_library(ANTLR_LIBRARY NAMES libantlr-pic.a libantlr.a libantlr2-0.dll libantlr3c.a antlr.lib PATHS /usr/lib /usr/local/lib ${WINDOWS_DEP_PATH}/lib)
 
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
@@ -138,16 +142,19 @@
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
 
 
 # Finding antlr library.
-find_program(ANTLR_EXE NAMES antlr runantlr cantlr antlr2 antlr.bat PATHS /usr/bin /opt/local/bin /usr/local/bin C:/antlr/277/bin)
+find_program(ANTLR_EXE NAMES antlr3 antlr runantlr cantlr antlr2 antlr.bat PATHS /usr/bin /opt/local/bin /usr/local/bin C:/antlr/277/bin)
 
 # Finding SED
 find_program(SED_EXE NAMES gsed sed PATHS /opt/local/bin /usr/local /bin ${WINDOWS_DEP_PATH}/bin)
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
+++ b/CMakeLists.txt	2017-04-01 16:22:51.000000000 +0100
@@ -24,14 +24,14 @@
 
 enable_testing()
 
+set(CMAKE_MACOSX_RPATH 1)
+
 # Setting up Project includes.
 list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake)
 include (srcml)
 
-set(CMAKE_MACOSX_RPATH 1)
-
 # Setting up source include directories.
-include_directories(BEFORE src/srcml src/libsrcml src/parser src/srcSAX)
+include_directories(BEFORE /usr/local/include /usr/local/opt/libxml2/include/libxml2 src/srcml src/libsrcml src/parser src/srcSAX)
 
 # Setting major and minor version numbers (TODO fix this so that it is set using something
 # more correct that being input from within the build system).
diff -r -u a/src/CMakeLists.txt b/src/CMakeLists.txt
--- a/src/CMakeLists.txt	2015-05-20 02:36:48.000000000 +0100
+++ b/src/CMakeLists.txt	2017-04-01 16:22:42.000000000 +0100
@@ -36,7 +36,7 @@
 # 
 macro(buildLib LIB_NAME LIB_TYPE)
 
-    add_library(${LIB_NAME} ${LIB_TYPE} $<TARGET_OBJECTS:parser> $<TARGET_OBJECTS:libsrcml> $<TARGET_OBJECTS:srcsax> build_hack.cpp)
+    add_library(${LIB_NAME} ${LIB_TYPE} $<TARGET_OBJECTS:parser> $<TARGET_OBJECTS:libsrcml> $<TARGET_OBJECTS:srcsax>)
 
 if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
     set_target_properties(${LIB_NAME} PROPERTIES OUTPUT_NAME libsrcml LINK_FLAGS_DEBUG "/SAFESEH:NO")
@@ -68,6 +68,6 @@
 elseif(OS_NAME STREQUAL "openSUSE" AND CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
 	install(TARGETS srcml_shared srcml_static RUNTIME DESTINATION bin LIBRARY DESTINATION lib64 ARCHIVE DESTINATION lib64)
 else()
-	install(TARGETS srcml_shared srcml_static RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
+	install(TARGETS srcml_shared srcml_static RUNTIME DESTINATION /usr/local/Cellar/srcml/0.9.5/bin LIBRARY DESTINATION /usr/local/Cellar/srcml/0.9.5/lib ARCHIVE DESTINATION /usr/local/Cellar/srcml/0.9.5/lib)
 endif()
 
Only in a/src: build_hack.cpp
diff -r -u a/src/libsrcml/CMakeLists.txt b/src/libsrcml/CMakeLists.txt
--- a/src/libsrcml/CMakeLists.txt	2015-05-20 02:36:48.000000000 +0100
+++ b/src/libsrcml/CMakeLists.txt	2017-04-01 16:28:35.000000000 +0100
@@ -23,4 +23,4 @@
 add_library(libsrcml OBJECT ${LIBSRCML_HEADERS} ${LIBSRCML_SOURCE})
 add_dependencies(libsrcml parser)
 
-install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/srcml.h DESTINATION include)
+install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/srcml.h DESTINATION /usr/local/Cellar/srcml/0.9.5/include)
diff -r -u a/src/libsrcml/srcml_reader_handler.hpp b/src/libsrcml/srcml_reader_handler.hpp
--- a/src/libsrcml/srcml_reader_handler.hpp	2015-05-20 02:36:48.000000000 +0100
+++ b/src/libsrcml/srcml_reader_handler.hpp	2017-03-31 18:27:04.000000000 +0100
@@ -456,7 +456,7 @@
 
             if(uri == SRCML_CPP_NS_URI) {
 
-                if(archive->language != 0) {
+                if(archive->language) {
 
                     if(*archive->language == "C++" || *archive->language == "C" || *archive->language == "Objective-C")
                         archive->options |= SRCML_OPTION_CPP | SRCML_OPTION_CPP_NOMACRO;
diff -r -u a/src/srcml/CMakeLists.txt b/src/srcml/CMakeLists.txt
--- a/src/srcml/CMakeLists.txt	2015-05-20 02:36:48.000000000 +0100
+++ b/src/srcml/CMakeLists.txt	2017-04-01 16:32:13.000000000 +0100
@@ -30,4 +30,4 @@
     install(CODE "execute_process(COMMAND \"/usr/bin/strip\" \"${CMAKE_BINARY_DIR}/bin/srcml\")")
 endif()
 
-install(TARGETS srcml RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
+install(TARGETS srcml RUNTIME DESTINATION /usr/local/Cellar/srcml/0.9.5/bin LIBRARY DESTINATION /usr/local/Cellar/srcml/0.9.5/lib ARCHIVE DESTINATION /usr/local/Cellar/srcml/0.9.5/lib)
