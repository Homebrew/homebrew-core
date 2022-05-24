class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.215.tar.gz"
  sha256 "c9a310f30533484d3832162416aa5c3a64101defc3e20bb4316e78b396bec85c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59478294943a5280c172645dc2863f344c6818ce5b63fde974c5d874ccb4164e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
