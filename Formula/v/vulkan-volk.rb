class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.3.290.0.tar.gz"
  sha256 "bb6a6d616c0f2bbd5d180da982a6d92a0948581cec937de69f17883980c6ca06"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45d20ff56705f3e04787bb7af939298516a9546565ceb6ef7602fcddd7b209d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1b2ffb01af22a4ce463af8d5d774e6e3aab76c19419fa4e3c0a2e83436a67f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b83c4ea6e0c5462daae7c7462f16065e42d4942861510d6594ce4ad5652f97"
    sha256 cellar: :any_skip_relocation, sonoma:         "64a764f27d4f4e867f2b1eb66ad00e5b10d702c32f58a3d168a8178e100dab8a"
    sha256 cellar: :any_skip_relocation, ventura:        "944b64142caaedca243b121cd1635025b048f7764047184886896b70f9284fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "bd62213616fbe0684ea2af510c6092031741341bad26f475eb5f1df482473d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46637c86fd93e5cc6819fe19c67ba236733485726a3ef496b1c2e05fe9fe2ee3"
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
