class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.206.tar.gz"
  sha256 "0cd46249eabb7cd8eab6ffc1b16d30a3a14e6e1e01d3d735b22dad33ee3efcf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0498c4c3d187bbfa6eb83c72f19cb56f8d0f9c8825616133f501bdfb8590af1"
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
