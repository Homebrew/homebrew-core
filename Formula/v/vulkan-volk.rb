class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "a04f26f76e9a4f9acf936bd2c159f5c4c8348f8ebaf118ff72ba6a9637ad3e80"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42737514660db3603287af33cba34c8284657afb65602d1c515f8559471f522b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b019c6e850ca86b1944fcfbf0ebb5f118152a2f1f2115ad25459927b53da37a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90c534582929c2324a7694986b254f3c2924f6b83e990e368e9187e3fc3daf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "581afb0ef931e3e0d09a0f345037f76495b4cdb03349ceb9ca07134b4fb57e85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22e9b161000d55a7a4a544168a8502d3d0a949a61d44321a1bbc49584db2362c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1192aef4a85f5fc28530ffde25c0e28f740bc495bf2359295968a51ce96c5bc"
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
