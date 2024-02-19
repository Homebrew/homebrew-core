class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.3.275.0.tar.gz"
  sha256 "b68d24e139190e49e5eafd72894f6e85c80472b8745bddc6ef91d6bf339df813"
  license "MIT"
  revision 2
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "235bab913c770c9e20656c0590f06190d2d85b6b5d49ddd11b2d6ea19320ce7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97699b468ff1e9cfc3a79aedddfd5976607f520fe4f1454dbc950178a552476a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf51d17740fe46d159ba00a32a818db6b08ec4442f4a0b362c729447504f6ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "8afd99e6578a1e55a2d3eed34c07abc56db866393edd27b40ba52cb0420a5a2f"
    sha256 cellar: :any_skip_relocation, ventura:        "48af8d3d969195c3633258b220ad8a2bac2108ec279b2b4da9e22372d1ef5050"
    sha256 cellar: :any_skip_relocation, monterey:       "faf60710db7c02db94ffa0f56f9e27a4ecf50edbe46deb0af87a36d738518e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092e5cc8b832136b0afd09a9f82bd6fa62fb2b18cc64ad9487824d86ac31f072"
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
