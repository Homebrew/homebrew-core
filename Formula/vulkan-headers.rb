class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.192.tar.gz"
  sha256 "c5508b4bfd289aee8a86a716f0f465f7ebd33d18ff1187e6018b06dba19d3a07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03480dc293e650c06d63a38125bf293e3ce69b838b01835675ba164fd0960c4c"
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
