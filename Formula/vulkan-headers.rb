class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.239.tar.gz"
  sha256 "86ef8969b96cf391dc86b9c4e5745b8ecaa12ebdaaefd3d8e38bc98e15f30653"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46f0941d3210dff9b96a75aa615ac89f863180306a2038569103c57bb30835b2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
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
