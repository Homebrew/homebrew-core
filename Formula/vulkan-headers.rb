class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.128.tar.gz"
  sha256 "28537d856d7c8b555fd8ac1ded244feeaade1d5e958a0ca4d999971efdb8f611"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef5296477b3482da25f1b9c98fd934b821915e9d1dfaa73b4a46549ef9687583" => :catalina
    sha256 "ef5296477b3482da25f1b9c98fd934b821915e9d1dfaa73b4a46549ef9687583" => :mojave
    sha256 "ef5296477b3482da25f1b9c98fd934b821915e9d1dfaa73b4a46549ef9687583" => :high_sierra
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
