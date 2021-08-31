class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.190.tar.gz"
  sha256 "ce997a3d6f43f9697c5ec232efb0f6e7826d0648412ed141f9495e88429075e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d75cc53e9a4ca0dde269088e368ceab02154de8b109fbb680796e7d0ccdce4b8"
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
