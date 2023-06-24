class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.255.tar.gz"
  sha256 "8e1db7041ad6dbaf4f3326a297b4aee17f3178a0d1cf9cd76a3f934c855357b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43818f039f486ee80a6ed21d379698d8c5b3331b9249ab6472b4f4ffb062757a"
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
