class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.204.tar.gz"
  sha256 "2cde2c90975a8f36d00cf8eb6308cb00323aafbc0b7374f4b346f1140f760b3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34738cf988a7791d62e692e0a0c34f7a50b3f0291a56ef9cac7eca5868bbc22a"
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
