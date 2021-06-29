class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.183.tar.gz"
  sha256 "79d8ac82f9837a9c09d6149cae032a99a314c6aa506086f5f6c260c9190b8ef7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2107441497b37bc9c7f74291599a85fb6892da77f78de5799c1cd8e493fdad55"
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
