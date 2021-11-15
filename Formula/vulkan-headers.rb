class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.198.tar.gz"
  sha256 "0b2c69bc392a0022652f65efe5c51ec39ae90ec427065a914ba74ac6c728db30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e5a8e206582fc6a66975e40cc5d1924823b92e62e588c7d766ba1402cec06ab"
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
