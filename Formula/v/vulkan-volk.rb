class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.3.296.0.tar.gz"
  sha256 "8ffd0e81e29688f4abaa39e598937160b098228f37503903b10d481d4862ab85"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b99b0b888a2d3de270867cce28f076bfd0744c8d9aa36a697cc4293fa716569"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d90480c5b9e185b5d8da54c0cdb0d84f3e72e504b807f8aef5e01eb78a61f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1068b9cfa7e55dccf92966543db170ceaa45f960cbb5215c6f68a43b63cf3b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b23d18952a47184732019fe4f40c6c5102f4bc61e21a234929984c2629696ef"
    sha256 cellar: :any_skip_relocation, ventura:       "465f40c01b82dc763d522a7001d8abb33fe7f7c054dda339ceadef7ca491fec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e13b32555f1e138bc348763f1058cb007bc57db26bc3cd5c078f417faf9504bf"
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
