class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "8d6a4092d5de62d0c6290394cf81cf7a99e36875934b1b75d595e76d08fcadd1"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e674a2b40e978b2146e6e163902f56ae953c881541d2bb3c0a2034889f4ba750"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d80186aa7965a923549ab0eafdd485e59ea5ae0d31271aac130e0300f6aea9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb944471c4ebd519fe8a7456c09fc17ad22249c88ff998a3e7e3201187cae7a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7602f7e532461ebf7bc4bee741b654ae901f5cd8107815ce5d1a027abcead1ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "826c7b85686e90eb0c28051a8ba54ed4bebb96370232be03e023ec339e45ee38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c120a25ac0f05121f45a4b412f68bdde42445ca143964c339599cf957c69fe5"
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
