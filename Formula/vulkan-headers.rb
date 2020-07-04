class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.146.tar.gz"
  sha256 "2b068692cedf549274bb6a314499d14a2a84ff83560cb26983c21c7e2422c253"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6755cfa8655a26943b49675de9aeb4edfb4936fb5f4a05ad5b4a314a42060ec" => :catalina
    sha256 "f6755cfa8655a26943b49675de9aeb4edfb4936fb5f4a05ad5b4a314a42060ec" => :mojave
    sha256 "f6755cfa8655a26943b49675de9aeb4edfb4936fb5f4a05ad5b4a314a42060ec" => :high_sierra
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
