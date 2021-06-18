class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.180.tar.gz"
  sha256 "ed4974bd223e3868db3be66c2f1fe0eb85de6ecc897a9a7da2e263a98abdd214"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36e8b1daef998bec5b6e8f4fcbdea51bf19316e43a6731739096ef3f27546790"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
