class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.141.tar.gz"
  sha256 "328a4b04e5e9206db64c4da543e725be551c486b91bb4d74a253fc115f83b4c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d1f7a182e69a2098dc84dfc9d40537ffac02d0efd2001b3f7f94e3b353a3cdc" => :catalina
    sha256 "3d1f7a182e69a2098dc84dfc9d40537ffac02d0efd2001b3f7f94e3b353a3cdc" => :mojave
    sha256 "3d1f7a182e69a2098dc84dfc9d40537ffac02d0efd2001b3f7f94e3b353a3cdc" => :high_sierra
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
