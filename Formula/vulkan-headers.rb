class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.102.tar.gz"
  sha256 "5a1746eee17c59fc68501b6cceb6753e570ecee81e8358e17ec857666bc592fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "07e0aa65a2280cb9e45105a64369627c155d9d42de4843a7a7ee5d49668e8d74" => :mojave
    sha256 "07e0aa65a2280cb9e45105a64369627c155d9d42de4843a7a7ee5d49668e8d74" => :high_sierra
    sha256 "35c5695e5c2e8810b6d21d7c3541f869a3c2cc651af2d82d66d563cea7f707ad" => :sierra
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
