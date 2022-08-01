class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.223.tar.gz"
  sha256 "da6b5604e6f5be48c97fbb122fd7ffdde97e6f1442c5ddbb854d50c3dda962fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26d7b1642154aa8e1cac3add8c264fe5f56bf409c902bf51fd1de673e792b31c"
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
