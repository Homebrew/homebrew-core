class Uvw < Formula
  desc "Header-only, event based, tiny and easy to use libuv wrapper in modern C++"
  homepage "https://github.com/skypjack/uvw"
  url "https://github.com/skypjack/uvw/archive/refs/tags/v3.4.0_libuv_v1.48.tar.gz"
  version "3.4.0"
  sha256 "c16600573871a5feeb524234b378ab832c8971b2a68d030c6bd0e3077d416ade"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]libuv[._-]v?\d+(?:\.\d+)*)?$/i)
  end

  bottle do
    rebuild 1
    manifest_sha256 "cf3fbbb131084afe99550e06421ece68bbb35834bbcf9633e44c5d0e78593ec2"
    sha256 cellar: :any, arm64_golden_gate: "c0e0a4c49edd58bb295f4c55834c565904b1255e234a6780e09343639809b5a7"
    sha256 cellar: :any, arm64_tahoe:       "42f2b4aec1058b1959d6772d03238e140df608a37d6d3d2c720439ef5392e114"
    sha256 cellar: :any, arm64_sequoia:     "5c6d17ad4df22eb84f5d18705e6c9903c7bb58626fb0e5d87d976f06efbefee1"
    sha256 cellar: :any, arm64_linux:       "9403b627bb463bb83f3643e14af0404864a4117cc582ed230c067a5db253dfd6"
    sha256 cellar: :any, x86_64_linux:      "4027e598a804b25ccccb36e5bc9560414243bbeeb211892bdd8c356078e46ca9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libuv"

  # Unofficial patch to fix shared library build. Corresponding upstream PR
  # https://github.com/skypjack/uvw/pull/333 is for main branch / 3.5.0
  patch :DATA

  deny_network_access!

  def install
    odie "Update CMake options which have been renamed!" if version > "3.4.0"

    # Disable UVW_USE_LIBCPP to rely on default rather than forcing libc++
    args = %w[
      -DBUILD_DOCS=OFF
      -DBUILD_UVW_SHARED_LIB=ON
      -DFETCH_LIBUV=OFF
      -DFIND_LIBUV=ON
      -DUSE_LIBCPP=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test_uvw)

      set(CMAKE_CXX_STANDARD 17)

      find_package(libuv REQUIRED)
      find_package(uvw REQUIRED)

      add_executable(test main.cpp)
      target_include_directories(test PRIVATE ${uvw_INCLUDE_DIRS})
      target_link_libraries(test PRIVATE uvw::uvw)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <iostream>
      #include <uvw.hpp>

      int main() {
        auto loop = uvw::loop::get_default();
        auto timer = loop->resource<uvw::timer_handle>();

        timer->on<uvw::timer_event>([](const uvw::timer_event &, uvw::timer_handle &handle) {
          std::cout << "Timer event triggered!" << std::endl;
          handle.close();
        });

        timer->start(uvw::timer_handle::time{1000}, uvw::timer_handle::time{0});
        loop->run();
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2be8ae8..7a1f6c5 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -103,7 +103,7 @@ function(use_libuv)
     if (FIND_LIBUV)
         find_package(libuv ${LIBUV_VERSION} QUIET)
         if (libuv_FOUND)
-            add_library(uv::uv-shared ALIAS uv)
+            add_library(uv::uv-shared ALIAS libuv::uv)
             set(FETCH_LIBUV_DEFAULT OFF)
             message(STATUS "libuv ${libuv_VERSION} found via cmake")
         else(libuv_FOUND)
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 584abfc..016c5f6 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -65,7 +65,7 @@ if (BUILD_UVW_SHARED_LIB)
     add_library(uvw SHARED)
     add_library(uvw::uvw-shared ALIAS uvw)
     # If libuv is not fetched by ourselves, it's the caller's responsibility to make sure of the linkage.
-    if(FETCH_LIBUV OR libuv_FOUND)
+    if(TARGET uv::uv-shared)
         target_link_libraries(uvw PUBLIC uv::uv-shared)
     endif()
 else()
