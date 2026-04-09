class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.341.0.tar.gz"
  sha256 "42df539c70ffdaea259e317aef73524512f4093f6f4dafb36fa6cf2680c823b9"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2de1b4a4bd37459f8eac627af471e3026d88f516a5e428a84faa3f50557f06c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34e1fc70424d67d5bf5a23000889fc2835b352f223aa3bcb4aca7b38ee4c1c90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5cfce5fbbf657db74e60f839596f8dbbcd77b2b633fe533133ec722877daca"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14f7d005be4ffed9d7737c4557b15a1d659f160f8a06a292e825a2a3a107e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4a847bb24e391265d104037e86aac0fffb06a76e8d544012deede7e0a91684d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0934296bdcdafe16ebbccf85177c538b6239058d9b5c11d235ab74654225d558"
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
