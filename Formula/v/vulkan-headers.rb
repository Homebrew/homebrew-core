class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.265.tar.gz"
  sha256 "24076540521da1eceecfb56235cb0361a01fb24a306cbefe874c949bf2d2e9a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdff6e0f06c93f77221e1c95fb9af0cd1c51b6866c753760eeabdd5a1f71f1ed"
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
