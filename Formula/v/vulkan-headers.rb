class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "c465aa56757e7746ac707f582b6e2d51546569a4a2488c1172fb543aa5fdfc2c"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b78a44b24b4e13e63d05e9c3b72e4a37d17dc27caaabbbbf857d8cb64fe5050"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
