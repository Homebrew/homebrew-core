class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.253.tar.gz"
  sha256 "e45a8c4289b84317252451055b0ac76b13169e10a9f619961fb6479bf6179054"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e751552e0ef74c628343d71a9e44adccf94fe84deb5d1c47cce440c7db88cce2"
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
