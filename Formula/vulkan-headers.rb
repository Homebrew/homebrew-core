class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.206.tar.gz"
  sha256 "0cd46249eabb7cd8eab6ffc1b16d30a3a14e6e1e01d3d735b22dad33ee3efcf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c738c968ac86a79d8c8759e318378244598dd8f7ca1da24cc6a5ba97efb278ef"
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
