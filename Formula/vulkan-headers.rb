class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.108.tar.gz"
  sha256 "22f1ea49067cc16635dbb33cc2eeb8358a48d4288b2e587784ba89d90c9ebfce"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a3a96464aef83ab698380ad81024fe1dac0801e13409a830217cf0552d26a76" => :mojave
    sha256 "9a3a96464aef83ab698380ad81024fe1dac0801e13409a830217cf0552d26a76" => :high_sierra
    sha256 "9c144937d368f2c312727be74bca45a97e6c4dbb6c86a3c5680ab94744a0f050" => :sierra
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
