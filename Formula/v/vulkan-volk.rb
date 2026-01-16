class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.335.0.tar.gz"
  sha256 "ca2beb1ab9bf272895bc0152ef29b437d178d837bae4a76d0022b7bbafb3c483"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74133825cad138708511c5da76dd859303347043232ccfd34f66054e01250039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59158387ce00cdafd0f3e84c72b338c2dc4089238ad498a7d2dbb9edd11296d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb8bd945463edae839990a0c06dfd6081547caaa85043281af21cff12141383"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e3b8014d920b01b40c7602f0ecbb8f8b992f2be99e2bf83cc508e72aa8c289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f49b63c10e2890244f446194e1eeecb6c73ef463d436135fedcc990ea8bcd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "234b2fc8135b4f38d38c43c61b126d0214ff845fe71d7390b1429d378d10286e"
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
