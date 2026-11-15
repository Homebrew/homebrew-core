class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
  sha256 "1547d8d74395d4048fb3f4a6313da56db626e89b55db238d0d7e8944c8a645f3"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e926e3f9dcac9d6d37133c9d08e22eda3fcef34de5020b92aa856b58a2848c3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79016e63a2ca3a22580c510f53e71547350b5e21f5256041f3388c58c7a5bd23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38eda90543cb761546c42d1a5b2ec5de676c506ce8ad25b69fde7a928e2e26bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad79a471965cef944005bee8a6ac6b43ded50aa18e0abd9049d654a6fe8296b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c63e0e1ab5580473b06d784e99009a2ef55087f01e24e8be658accb06d432106"
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

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVOLK_INSTALL=ON",
           "-DVULKAN_HEADERS_INSTALL_DIR=#{formula_opt_prefix("vulkan-headers")}",
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
           "-I#{formula_opt_include("vulkan-headers")}",
           "-lvolk", "-D#{volk_static_defines}",
           "-Wl,-rpath,#{formula_opt_lib("vulkan-loader")}",
           "-o", testpath/"test"
    system testpath/"test"
  end
end
