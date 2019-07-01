class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.113.tar.gz"
  sha256 "d299d11bc2bdc2faff62768d91bd5aa2b344b499282c969d542657b82fec7656"

  bottle do
    cellar :any_skip_relocation
    sha256 "707f816245c1527d6ef4b35b4540be33a82c32fc86b36398a646e8477ebdf810" => :mojave
    sha256 "707f816245c1527d6ef4b35b4540be33a82c32fc86b36398a646e8477ebdf810" => :high_sierra
    sha256 "825533f450c1fc7d8073fa177d79014db7770d5124103c68d31da513f37859ae" => :sierra
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
