class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.122.tar.gz"
  sha256 "00874cff60bb167c9ee4a60d6f17107e082a44dacaacf9e6a9da5fd2cca1f3c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e002846360df87635225ea84914143dc6f462f0c982b17181bb988c1e7f07122" => :mojave
    sha256 "e002846360df87635225ea84914143dc6f462f0c982b17181bb988c1e7f07122" => :high_sierra
    sha256 "5fa450745ddfd6ea10e03fabdea86aadb531f5394c05bb401e38729a56983cef" => :sierra
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
