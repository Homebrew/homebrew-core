class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.3.275.0.tar.gz"
  sha256 "b68d24e139190e49e5eafd72894f6e85c80472b8745bddc6ef91d6bf339df813"
  license "MIT"
  revision 5
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b723aeb66a564e84642c43e8eb9e93f97022aab05fdc8122fd108048d523847"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccfc8c979221cfb8a86d6e9bcf7185822a723ca79d84b87eef479acf4a06b354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a30ae45ba6b79b5f6ab3baaa66127550a3e8fab884efd47f3f38ed9b5153443"
    sha256 cellar: :any_skip_relocation, sonoma:         "46a70ddbc9e19e55da592b422682eb6841017edd6abbd980f3b6941076a6840b"
    sha256 cellar: :any_skip_relocation, ventura:        "8cb253007a33951e54076a5fc499ab8732d8b545dc848c72ed07c8ec672345f2"
    sha256 cellar: :any_skip_relocation, monterey:       "7f21856099db49707fbfad648adb7542632af41d57e17ec6706eb4db3be1c013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2cf496b1d2a9160abfecf26e8358060a1fe058353b9acb5bc601b5a6da5830"
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, testpath/"test.c",
           "-I#{include}", "-L#{lib}",
           "-I#{Formula["vulkan-headers"].include}",
           "-lvolk", "-D#{volk_static_defines}",
           "-Wl,-rpath,#{Formula["vulkan-loader"].opt_lib}",
           "-o", testpath/"test"
    system testpath/"test"
  end
end
