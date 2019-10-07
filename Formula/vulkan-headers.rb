class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.124.tar.gz"
  sha256 "ef33146bfc92a4889de8e9cc4b135740b5651b2250b0e8483ea745ce5894a04b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5f67f8d38d2462570a3d2ccfbad06ba0a288baddfa839663d0547ff29a3456f" => :mojave
    sha256 "f5f67f8d38d2462570a3d2ccfbad06ba0a288baddfa839663d0547ff29a3456f" => :high_sierra
    sha256 "46acd70fb0aea03e6f7be32f9a32ee86e3b505d0765d858734b7c63fd965841b" => :sierra
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
