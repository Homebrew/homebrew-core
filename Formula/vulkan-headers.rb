class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.187.tar.gz"
  sha256 "37f399aef2dbeb0eb979139f41a0fe411b3dff77e70be85e93318a7b833557de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85c33a7289857424060b4707db7c8c811878d3ee6ccc1cd58ec4c0767f328672"
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
