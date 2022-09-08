class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.227.tar.gz"
  sha256 "5b345a9f0dafc96e4d0cd2d95547702c4451691dc731f6b486ba36fd9bab7bfe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d4653eae9c6af70b097e59fe2f12befdab3b76847b4a26a3ae9be7528c8cee8"
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
