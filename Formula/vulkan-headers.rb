class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.112.tar.gz"
  sha256 "612fd9a7d9b95f29253d759570f37a3dd6a073d4b2dc5e94a9734a23d9c476f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ae1477e61ca76bb3a0332b9b2819c629502dcdb6bccb6ec636ea35ebcfaf89b" => :mojave
    sha256 "7ae1477e61ca76bb3a0332b9b2819c629502dcdb6bccb6ec636ea35ebcfaf89b" => :high_sierra
    sha256 "20c75b7892273bb50298d5f7207fab0a837a4fb8c2e61ba3f05a580dc44dd8b5" => :sierra
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
