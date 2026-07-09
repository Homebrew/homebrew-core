class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.350.1.tar.gz"
  sha256 "078a9411298e4e0f60f5f5398c890783427c25a414619294ca8e69587bbd5eae"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6496c743f4bc00291a77bb361ad5c7888cdb0bb97f996bffad7c23e29ae87aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3106c0c0ad9941b09520e5587573aa075a034e79784877cddca5a2bd664acaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "698accc547d0da7ba385776170dcdda8b4079ecd432bd807e038763936621a77"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f484860b5114173d43c61608d43d454d21748c78b2f3be4d017ba23a8e828d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ccc8903d3a2bf07871e23cde12f5492022d0217a1536fb2933d526bc33ee270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15aa58866338c3c39e5f3530de07975260a72ff8aa290c287e9728a06c2ca079"
  end

  depends_on "cmake" => :build
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader"

  conflicts_with "volk", because: "both install volkConfig.cmake"

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
           "-DCMAKE_INSTALL_RPATH=#{rpath(target: formula_opt_lib("vulkan-loader"))}",
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
           "-Wl,-rpath,#{formula_opt_lib("vulkan-loader")}",
           "-o", testpath/"test"
    system testpath/"test"
  end
end
