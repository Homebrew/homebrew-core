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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "949dd91ce4fec8c352466645b29c4b34364b7fc4193279b8037b275674e0be25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e969576ad888cb439282cdd69b56fedeb0ed92d053cf039e60605fb0ba605a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5d4d43245ac7e7bdef2b5a657bdc69985639aff0b90e0d6766bdd503bc51e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbfc54509d3ca24290a0ca0788982baad14417c9fb5a51e6e78cb8effbf99184"
    sha256 cellar: :any_skip_relocation, ventura:        "f8125c4da1cc3a0827a0516d8fae62da3ec2cf0d0425129f877146b1714b27ef"
    sha256 cellar: :any_skip_relocation, monterey:       "44f1083d1513aaef1191d2ca0351a475c8c2ffb4b6a5538e6d0b4c0b0cfad491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85df8371339b72616368ce8bfd3d6da3f7f9154b49e11b81357fee00f178c77c"
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
