class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.195.tar.gz"
  sha256 "8d6e561871bb4dbb7f83e80eac41b3a582dbd874382990c7e4972cb0258fa529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c83b4e6621cc4da06f0c1ff63532ad1d143a7bdaf0d62122875510d3a7e1247"
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
