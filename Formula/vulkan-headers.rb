class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.229.tar.gz"
  sha256 "fe620275ca1e29501dcb3f54c69cc011b6d9c3296408fac4e18dc491a1be754f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d83ba07bd8abe979db0e90c54c5d1a676e98779d6f414dfdaa11d4d431f397f"
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
