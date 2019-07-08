class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.114.tar.gz"
  sha256 "5de27c6249aad312868dd7085f5ad2443b4d1f0fbbd0abfaea4f145300d9c254"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d6fb71d4e658e72edd9c3c45d100d86243dfc8e48623b502c0018ec6e2337ce" => :mojave
    sha256 "4d6fb71d4e658e72edd9c3c45d100d86243dfc8e48623b502c0018ec6e2337ce" => :high_sierra
    sha256 "0ebb78867d41f134c72722b18c8fc2a3f1e3b0c408916ef816b844d77196d56a" => :sierra
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
