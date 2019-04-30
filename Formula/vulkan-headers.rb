class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.107.tar.gz"
  sha256 "7d00748f3311a89d5a92aea4b11764bb8371dae4ab6291497bcde2fa186bbd31"

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
