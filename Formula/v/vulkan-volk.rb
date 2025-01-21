class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.304.0.tar.gz"
  sha256 "2a563c9dd926c804d91d7b84c59516678ccb32d039038049fc20eb22547c88fb"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aee4fb59d3f267e8b2b39622b0991b41e098573e2c45385be2fc451ce714637a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b48f1b6b9303b0a5f3d9f165a29f61f39daecbe0de3a0005d857a95c7ab319bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f4240d466c92ee942fcec6c6514f942c0247c30ba532f633e5292768a707bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "51087cc3da7daefb9e7031d07b26927fc9628ee940d464c02c40daafeb25049f"
    sha256 cellar: :any_skip_relocation, ventura:       "c866a1242f9ee9938ed34ad1d6a7f956410d94d3963abc28564d330d3f2c2edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b001e1b4c1f1539126d272f332bc93f64ad06121f9f43c3d376f434e39df8a"
  end

  depends_on "cmake" => :build
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader"

  conflicts_with "volk" => "both install volkConfig.cmake"

  def volk_static_defines
    res = ""
    on_macos do
      res = "VK_USE_PLATFORM_MACOS_MVK"
    end
    on_linux do
      res = "VK_USE_PLATFORM_XLIB_KHR"
    end
    res
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVOLK_INSTALL=ON",
           "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
           "-DVOLK_STATIC_DEFINES=#{volk_static_defines}",
           "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "volk.h"

      int main() {
        VkResult res = volkInitialize();
        if (res == VK_SUCCESS) {
          printf("Result was VK_SUCCESS\\n");
          return 0;
        } else {
          printf("Result was VK_ERROR_INITIALIZATION_FAILED\\n");
          return 1;
        }
      }
    C
    system ENV.cc, testpath/"test.c",
           "-I#{include}", "-L#{lib}",
           "-I#{Formula["vulkan-headers"].include}",
           "-lvolk", "-D#{volk_static_defines}",
           "-Wl,-rpath,#{Formula["vulkan-loader"].opt_lib}",
           "-o", testpath/"test"
    system testpath/"test"
  end
end
