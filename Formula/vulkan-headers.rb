class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.213.tar.gz"
  sha256 "7f4a6118dc3524703c1ce0a44089379e89eeb930fbe28188b90fdac1f10ef676"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d146db92d6736780d5e5f16f89d826c166e8907c6ab3814a99ed862a3836600"
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
