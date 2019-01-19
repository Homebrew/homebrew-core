class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2019_U3.tar.gz"
  version "2019_U3"
  sha256 "b2244147bc8159cdd8f06a38afeb42f3237d3fc822555499d7ccfbd4b86f8ece"
  revision 2

  bottle do
    cellar :any
    sha256 "3b5ac43b2280ebbebc39541a95a63e287b08eceb8ba75912cd8b89f731ffe663" => :mojave
    sha256 "fc57daae5222af5ba8178f810113ac37066b40d268d3e30da78e1aeaa40cfd0f" => :high_sierra
    sha256 "77e4f8db4f7bc6c1327567a8944d5eb3ba5a6503cc1404e65f18284e1f7aabfd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on "python"

  patch :DATA

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}"
    lib.install Dir["build/BUILDPREFIX_debug/*.dylib"] # debug libs are required for find_package(TBB)
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]

    # Build and install static libraries
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}",
                   "extra_inc=big_iron.inc"
    lib.install Dir["build/BUILDPREFIX_debug/*.a"] # debug libs are required for find_package(TBB)
    lib.install Dir["build/BUILDPREFIX_release/*.a"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    system "cmake", "-DTBB_ROOT=#{prefix}",
                    "-DTBB_OS=Darwin",
                    "-DSAVE_TO=lib/cmake/TBB",
                    "-P", "cmake/tbb_config_generator.cmake"

    (lib/"cmake"/"TBB").install Dir["lib/cmake/TBB/*.cmake"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tbb/task_scheduler_init.h>
      #include <iostream>

      int main()
      {
        std::cout << tbb::task_scheduler_init::default_num_threads();
        return 0;
      }
    EOS
    # First do a simple build and linkage
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltbb_debug", "-o", "test"
    system "./test"
    # Now build using the the find_package(TBB REQUIRED CONFIG) cmake package manager
    (testpath/"CMakeLists.txt").write <<~EOS
      # Put this cmake file in a directory, run "cmake ."  finding TBB results in a FATAL_ERROR from cmake
      cmake_minimum_required(VERSION 3.0)
      find_package(TBB REQUIRED CONFIG)
      if(NOT TBB_FOUND)
         message(FATAL_ERROR "NO TBB")
      else()
        message(STATUS "FOUND TBB")
      endif()
      add_executable(tbb_test test.cpp)
      target_link_libraries(tbb_test TBB::tbb)
    EOS

    # BUILD against debug libraries
    system "cmake", "-DCMAKE_BUILD_TYPE:STRING=Debug", "."
    system "make", "VERBOSE=ON", "tbb_test"
    system "./tbb_test"

    # BUILD against release libraries
    system "cmake", "-DCMAKE_BUILD_TYPE:STRING=Release", "."
    system "make", "VERBOSE=ON", "tbb_test"
    system "./tbb_test"
  end
end

# Apply patch under consideration in PR#119 in upstream tbb
# https://github.com/01org/tbb/pull/119
__END__
diff --git a/cmake/TBBMakeConfig.cmake b/cmake/TBBMakeConfig.cmake
index 54fc7c6059b3..070ac4861d93 100644
--- a/cmake/TBBMakeConfig.cmake
+++ b/cmake/TBBMakeConfig.cmake
@@ -38,6 +38,7 @@ function(tbb_make_config)
         set(tbb_system_name ${tbb_MK_SYSTEM_NAME})
     endif()
 
+    set(TBB_ROOT ${tbb_MK_TBB_ROOT})
     set(tbb_config_dir ${tbb_MK_TBB_ROOT}/cmake)
     if (tbb_MK_SAVE_TO)
         set(tbb_config_dir ${tbb_MK_SAVE_TO})
diff --git a/cmake/templates/TBBConfig.cmake.in b/cmake/templates/TBBConfig.cmake.in
index 9094343cf835..4e1603f6114a 100644
--- a/cmake/templates/TBBConfig.cmake.in
+++ b/cmake/templates/TBBConfig.cmake.in
@@ -38,8 +38,7 @@ endif()
 
 set(TBB_INTERFACE_VERSION @TBB_INTERFACE_VERSION@)
 
-get_filename_component(_tbb_root "${CMAKE_CURRENT_LIST_FILE}" PATH)
-get_filename_component(_tbb_root "${_tbb_root}" PATH)
+set(_tbb_root "@TBB_ROOT@")
 
 set(_tbb_x32_subdir @TBB_X32_SUBDIR@)
 set(_tbb_x64_subdir @TBB_X64_SUBDIR@)
@@ -74,7 +73,12 @@ foreach (_tbb_component ${TBB_FIND_COMPONENTS})
         list(APPEND TBB_IMPORTED_TARGETS TBB::${_tbb_component})
         set(TBB_${_tbb_component}_FOUND 1)
     elseif (TBB_FIND_REQUIRED AND TBB_FIND_REQUIRED_${_tbb_component})
-        message(FATAL_ERROR "Missed required Intel TBB component: ${_tbb_component}")
+        message(STATUS "Missed required Intel TBB component: ${_tbb_component}")
+                              # Do not use FATAL_ERROR message as that
+                              # breaks find_package(TBB QUIET) behavior
+        set(TBB_FOUND FALSE)  # Set TBB_FOUND considered to be NOT FOUND if
+                              # required components missing
+        set(TBB_${_tbb_component}_FOUND 0)
     endif()
 endforeach()
