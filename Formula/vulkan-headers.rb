class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.191.tar.gz"
  sha256 "ff7c66144df271eeb5dec9ba6cd3773236b8d3a04df4bc55cc45a95e30287371"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1cd1f2596023758a96dfbe45aedd573ceb47b77bb525a2d40e54653f54c60680"
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
