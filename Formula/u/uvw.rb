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
    manifest_sha256 "099cec3da4eb6bcceaa7bd1fbdc42f48cf60f25a2804f3220e7d90e94e7f7a9d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6213226739fd0ece612aae0ec00bd14f5ed3fa0086a9c22e458e7f2dbe5b2d8e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "594413006be49d686f144c3122cb960e9eb204a9dbc3503dd7622b8051b61e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ffd8957741528fa17ff2883d204d9a86f58bf13f1d2d12e11b9e23436412c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bd6b702c8f2b647f207611e843ec0d36731982a20b61759e9aae7465f5e8cb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "d9cdb35b83cb69c02172ba1e43007e5d605d3fb4c3b3af40ebf24e34cd7dcba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey:    "5dfb062fab38ca015d435f5f324208a67a9414e2a823541eba2c720fb884af6a"
    sha256 cellar: :any_skip_relocation, sonoma:            "6e9929a431e28be34456a3c4eeffa04c4b045a98e416acc4727423d54a2c6815"
    sha256 cellar: :any_skip_relocation, ventura:           "d4a069f5c1bbb5d81410483e2a1989498acd3788827abb2ee38d30f590f5b65e"
    sha256 cellar: :any_skip_relocation, monterey:          "8bc362bc8cb3cf30ea27a8d4f4f9b5cd44b8290b45b440f6b6da97a6b22a7284"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "612431aeef05fad9b635b106bdd5fde18f7d03b30de86ff5e64f0655696aed45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1df5b81661883a5eb47d2156a1def7b605a78d8270c255e8c367b347d8b06ceb"
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
