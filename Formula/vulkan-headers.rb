class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.234.tar.gz"
  sha256 "0bbfebd602501476e6044719619a24d8b27338fbca3ae0c69fe1daa8d0ca9caf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eed3edc6b01809a0fc7e6da7beb038d572bc886380054adec3f0c65442436553"
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
