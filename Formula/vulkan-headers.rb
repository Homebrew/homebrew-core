class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.177.tar.gz"
  sha256 "1ba852b6983c481482361c63a65409d3b4e0a70b74aeb35e3d45593041eb4d4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d86fee2303f4fad7ca5e56776dd1ccb6a4dfa17ee8ee118aa8fedcddc31cbd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f2c17c525e3a61d0088da38a6bf4472aae7ec34500905dadc4108cbf6f1f626"
    sha256 cellar: :any_skip_relocation, catalina:      "3f2c17c525e3a61d0088da38a6bf4472aae7ec34500905dadc4108cbf6f1f626"
    sha256 cellar: :any_skip_relocation, mojave:        "41b6eb1721da5d5304153e0e861b756a95e7b938bf99d22e624b7f6385293e8c"
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
