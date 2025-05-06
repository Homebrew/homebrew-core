class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.313.0.tar.gz"
  sha256 "d86bcf1aff499f41a3e445b55df5e393a5ce49b1bda689eb7335b0a0a54a3c0b"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ad90313f5f630dbefea47e8d8561eaedc1dc659b7d8fd4209a62b10cdd2427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b9a1acdc8aa212409bc39ab15ef2481ffd6b6a4ef70540065bfd4c529ef364"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa901f6202a93f4637cafdc5bf235785037ab47b9ecc3f9de2c6d913a0b036a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b82d2bec7f1739b3eefe9c0e94b2600c82b6cbf12282bbae193f34f7901aa5dc"
    sha256 cellar: :any_skip_relocation, ventura:       "25ca80bfd5f0821f0563cf49180ae461c1112c155d4384cae0d1d5edef54a926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f05885083682f42c270745947ae747c5cf98d2aeacba8c0e54920571850f4d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75e37f363fe26c5c8eb7477529d0c857d5c0f1a31b0ffb7b047e0a05d759c42d"
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
