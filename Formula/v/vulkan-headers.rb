class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.3.274.tar.gz"
  sha256 "3458dd9049d561d0863069b1dd752cd4a04ca31fc090a58124691d61bff5b62a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51b2eb50e15e5f418080e6c180875667b3ff20226ce8c4ef0c1d1a8659615582"
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
