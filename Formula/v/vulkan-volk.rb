class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.321.0.tar.gz"
  sha256 "021ed905eea6f3e2cc8a60a21459ee7b43f98f32052ca30f27a3be390b7a4862"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d36ab92be5e1264512fc1167e8a0783bfc4d94159030ba7c11d76cafc26f3489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99e4c0586eaf099664769e549303fde82ba3cd50a1e8e163bfc18d0c525740db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9f2a9bdc89a383cca4d614129fd12c67156c0e0e378081589343ed79f56f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09c600ff16bcf8ae87fcdb602e357a9325b723f01ae30bdfc22c7f6a786dbe8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "02cff54f58df02f67611045a0920bb08db0cc867980a9911e5b74c0bad10ccca"
    sha256 cellar: :any_skip_relocation, ventura:       "60eb51a1674bf27164fb44dd7bfeb65f64f1f66030652a068addc823f26a165c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12867ef8aeb8fa56c168145d06c8eae971c6387b7b6669b680fb1391f06205c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea8baa917dd5dac29ee7937d2776264f7099aefb2768a02afb33e09efc7d4d1"
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
