class Terra < Formula
  desc "Low-level programming language embedded in and meta-programmed by Lua"
  homepage "http://terralang.org"
  url "https://github.com/terralang/terra/archive/release-1.0.0-beta1.tar.gz"
  sha256 "b8f01c47c3170cb30787cf7f6b6f1883234007597a241c6fc47d63b6390524bb"

  depends_on "cmake" => :build
  depends_on "llvm@6"
  depends_on "luajit"

  patch :DATA

  def install
    cd "build" do
      system "cmake", "..", "-DTERRA_VERSION=#{version}", "-DLUAJIT_INSTALL_PREFIX=#{Formula["luajit"].opt_prefix}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
    system "#{bin}/terra", "-e", <<~EOS
      function printhello()
          print("Hello, Lua!")
      end
      terralib.includepath = "/usr/include;/usr/local/include;#{sdk_path}/usr/include"
      C = terralib.includec("stdio.h")
      terra hello(argc : int, argv : &rawstring)
          C.printf("Hello, Terra!\\n")
          return 0
      end
      printhello()
      hello(0,nil)
    EOS
  end
end

__END__
--- a/cmake/Modules/GetLuaJIT.cmake
+++ b/cmake/Modules/GetLuaJIT.cmake
@@ -1,14 +1,21 @@
 include(FindPackageHandleStandardArgs)
 
+if(DEFINED LUAJIT_INSTALL_PREFIX)
+  set(USE_SYSTEM_LUAJIT 1)
+else()
+  set(USE_SYSTEM_LUAJIT 0)
+endif()
 set(LUAJIT_VERSION_MAJOR 2)
 set(LUAJIT_VERSION_MINOR 0)
 set(LUAJIT_VERSION_BASE ${LUAJIT_VERSION_MAJOR}.${LUAJIT_VERSION_MINOR})
 set(LUAJIT_VERSION_EXTRA .5)
 set(LUAJIT_BASENAME "LuaJIT-${LUAJIT_VERSION_BASE}${LUAJIT_VERSION_EXTRA}")
+if(NOT USE_SYSTEM_LUAJIT)
 set(LUAJIT_URL "https://luajit.org/download/${LUAJIT_BASENAME}.tar.gz")
 set(LUAJIT_TAR "${PROJECT_BINARY_DIR}/${LUAJIT_BASENAME}.tar.gz")
 set(LUAJIT_SOURCE_DIR "${PROJECT_BINARY_DIR}/${LUAJIT_BASENAME}")
 set(LUAJIT_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/luajit")
+endif()
 set(LUAJIT_INCLUDE_DIR "${LUAJIT_INSTALL_PREFIX}/include/luajit-${LUAJIT_VERSION_BASE}")
 set(LUAJIT_HEADER_BASENAMES lua.h lualib.h lauxlib.h luaconf.h)
 set(LUAJIT_LIBRARY_NAME_WE "${LUAJIT_INSTALL_PREFIX}/lib/libluajit-5.1")
@@ -26,6 +33,7 @@ string(CONCAT
   "${CMAKE_SHARED_LIBRARY_SUFFIX}"
 )
 
+if(NOT USE_SYSTEM_LUAJIT)
 file(DOWNLOAD "${LUAJIT_URL}" "${LUAJIT_TAR}")
 
 add_custom_command(
@@ -35,6 +43,7 @@ add_custom_command(
   WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
   VERBATIM
 )
+endif()
 
 foreach(LUAJIT_HEADER ${LUAJIT_HEADER_BASENAMES})
   list(APPEND LUAJIT_INSTALL_HEADERS "${LUAJIT_INCLUDE_DIR}/${LUAJIT_HEADER}")
@@ -50,6 +59,7 @@ if(UNIX AND NOT APPLE)
   )
 endif()
 
+if(NOT USE_SYSTEM_LUAJIT)
 add_custom_command(
   OUTPUT ${LUAJIT_STATIC_LIBRARY} ${LUAJIT_SHARED_LIBRARY_PATHS} ${LUAJIT_EXECUTABLE} ${LUAJIT_INSTALL_HEADERS}
   DEPENDS ${LUAJIT_SOURCE_DIR}
@@ -57,6 +67,7 @@ add_custom_command(
   WORKING_DIRECTORY ${LUAJIT_SOURCE_DIR}
   VERBATIM
 )
+endif()
 
 foreach(LUAJIT_HEADER ${LUAJIT_HEADER_BASENAMES})
   list(APPEND LUAJIT_HEADERS ${PROJECT_BINARY_DIR}/include/terra/${LUAJIT_HEADER})
@@ -76,7 +87,7 @@ foreach(LUAJIT_HEADER ${LUAJIT_HEADER_BASENAMES})
   )
 endforeach()
 
-if(TERRA_SLIB_INCLUDE_LUAJIT)
+if(TERRA_SLIB_INCLUDE_LUAJIT AND NOT USE_SYSTEM_LUAJIT)
   set(LUAJIT_OBJECT_DIR "${PROJECT_BINARY_DIR}/lua_objects")
 
   execute_process(

--- a/cmake/Modules/VersionNumber.cmake
+++ b/cmake/Modules/VersionNumber.cmake
@@ -1,3 +1,4 @@
+if(NOT DEFINED TERRA_VERSION)
 if(GIT_FOUND)
   execute_process(
     COMMAND "${GIT_EXECUTABLE}" describe --tags
@@ -16,5 +17,6 @@ if(HAS_TERRA_VERSION EQUAL 0)
 else()
   set(TERRA_VERSION unknown)
 endif()
+endif()
 
 set(TERRA_VERSION_DEFINITIONS "TERRA_VERSION_STRING=\"${TERRA_VERSION}\"")
