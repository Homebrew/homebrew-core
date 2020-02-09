class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.132.tar.gz"
  sha256 "43700844234dea88c1adf07a14a4c077c240a29927b82e6a06f36a23ffe8d08b"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dbe0ed02a5cfaa9bf89540da39a84222d1281c7becfc7778f7959d31f07d880" => :catalina
    sha256 "1dbe0ed02a5cfaa9bf89540da39a84222d1281c7becfc7778f7959d31f07d880" => :mojave
    sha256 "1dbe0ed02a5cfaa9bf89540da39a84222d1281c7becfc7778f7959d31f07d880" => :high_sierra
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
