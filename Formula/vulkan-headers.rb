class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.196.tar.gz"
  sha256 "33cb99194b5ab082beb00bda1e96311dfe2cb20b0037b6d4c8ae926a50f5a750"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd01995ab7a1c72cb2c6fc13c50faa700e35e976fc012d929909a52a014f325c"
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
