class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "6400c7b23e24d17e4f04bac49b55b06c4e87677d33398e90344743ec73560ca6"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c68e2b309f5483a7967a8a45bde15b16aa084608c5b55a13f04aeae9686ed180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "827a0398cc40ce8c3ffd7cfa883459b277fc850eba4cad861ed863524cb416c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2680a97c3ccbffc566040644922cb52041a805bc2ec8b736a224ec662e076213"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9f6d6c01b85710adde91a40688e1744da5e97867d7254ce7ea08499756eb53b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b730e103d15e781283e168fba2721d6d207020215949a210386f9a7fc2c4241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81ee606b88cf14a3398406d18fec110038458e8c7dff1cd5f2cf95c96e00fdc1"
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
