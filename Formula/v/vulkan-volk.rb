class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.3.275.0.tar.gz"
  sha256 "b68d24e139190e49e5eafd72894f6e85c80472b8745bddc6ef91d6bf339df813"
  license "MIT"
  revision 3
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d158ce691e3c6eda33ae308c84c407537610958e843606155844f32c32cf49e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f61abcf0ea4963cc2751835af74e9e752152ba63a47a8e294203658b5fa212b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74b3cee486ef3319f361ec1428ecbccc2df21711a4e6a09d9586d14b4a537fe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dea45065400e6798cd1ba1bb67585f278443d9072a4bdf58f09aa970144a0e6"
    sha256 cellar: :any_skip_relocation, ventura:        "cf0d6eac3bcc263384263acd310b1d91ec3fabbee13b087fae30eefe9aeca7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "52b033fb9942392de2ffde5f491c7b1facc73c50ca9998b4afae864df4d45953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9be0e6e3899d22fa7d15859d0ed85fa93a69c4477f046a2f965d55cb5988c2d7"
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
