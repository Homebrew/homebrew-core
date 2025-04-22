class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.309.0.tar.gz"
  sha256 "1724924d8e3dccf0c508887edb79d56d9dd11b0738eab5a44e2fa95b8a9ebe1c"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e4dc0e3a1942df6e02df444f827b3e42c75794ff70bd3b34125db66c2bf4eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a324b9cdc70d490f8a1198aa8d30ed5ed286aa5e50d25d759757b364ac4c79b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "009926026c7e06cf9d0a72a73bdc9732c4a6b3e98a54ab92d9c0e4f668d7e58d"
    sha256 cellar: :any_skip_relocation, sonoma:        "582fee33c65fb62e199d3ed80cb7b7f2c91c6381a1b0d1ac442958a0463614fe"
    sha256 cellar: :any_skip_relocation, ventura:       "1f0e8dc6a39f8d4c1a4090e27ab2daca59ec9f30640ab1215c8d4b744ed9f2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9940faf3769ddc8e8bf39c4381afdf2554f0b27ffd21699ae15e976d8f870c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b347974237c864c94513527a530041b7bbc70f175559b65f2512a0721647e89e"
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
