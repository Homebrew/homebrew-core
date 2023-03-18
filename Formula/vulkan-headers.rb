class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.244.tar.gz"
  sha256 "3c3da58940dcac5b007198f9bb0baf060044e86c992ffded3ac3ee31b5dceead"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75accef544b77d1fa5e4d1dec493027199b3c0d5dfac7376257ea66d91bbf3db"
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
