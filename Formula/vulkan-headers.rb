class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.126.tar.gz"
  sha256 "1d2933c62ace2de1a2ae3c0cea2265469e6ea58e02291a32dca7d08d23ecd3fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "95deb0f735a8d68b2e0396d265eb5750cbffbc4558858bf5c1f63e7a21a8c41f" => :catalina
    sha256 "95deb0f735a8d68b2e0396d265eb5750cbffbc4558858bf5c1f63e7a21a8c41f" => :mojave
    sha256 "95deb0f735a8d68b2e0396d265eb5750cbffbc4558858bf5c1f63e7a21a8c41f" => :high_sierra
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
