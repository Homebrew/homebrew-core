class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.222.tar.gz"
  sha256 "e4521bd92f704d0dd2586d6d164857667e0eee04db7e19643a1a3627d9153ea7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f16f91d7e544b67081240ee99595b398089540bbe700cee0be94f428ecc1bb4"
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
