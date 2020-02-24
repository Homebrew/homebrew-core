class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.133.tar.gz"
  sha256 "f293dbf8258d34bd7c23b7b667978b753834f30ae836ada04f6d35ed7cd6b9f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0576db7d1ea977f4bb0b232c1dd471081da53077b3b659023c657335c684b95d" => :catalina
    sha256 "0576db7d1ea977f4bb0b232c1dd471081da53077b3b659023c657335c684b95d" => :mojave
    sha256 "0576db7d1ea977f4bb0b232c1dd471081da53077b3b659023c657335c684b95d" => :high_sierra
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
