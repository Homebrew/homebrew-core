class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.212.tar.gz"
  sha256 "deea32809940711be36258e17ac887818f6261c96be27b24a1b82ac6718f0b2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d446551d340b9c76ee21d35e1a044a4a3f98a782988affa00c6c95870ff9f38d"
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
