class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.161.tar.gz"
  sha256 "0738f981c291743c2cb6024911fa1ecdfe1bdac67da6644019aeeff0925b5859"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6649473e272caf9186376d0ee5bace71dcb413de22ff8020db101929a618f845" => :catalina
    sha256 "a226dcd65ef2260c0fadf1f8d39a3dafce11bba4644fea58f1e7701377045213" => :mojave
    sha256 "4d604112d797af7da4b0c0d87110304937e12af376c77ec5944d2010364c5950" => :high_sierra
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
