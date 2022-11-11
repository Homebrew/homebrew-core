class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.234.tar.gz"
  sha256 "0bbfebd602501476e6044719619a24d8b27338fbca3ae0c69fe1daa8d0ca9caf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "467bd2a153f836c720bfed6689c8e410c00e4da9cb0e72f681e18cb26b8a972d"
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
