class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.240.tar.gz"
  sha256 "98734513f4847254ef5bdd31a9c897f64938dac0733b9aea9e4b3fd339d82281"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3685a8dc30c152d2e29550c650d0124f6323e82a8070d121608c151fd8197dfa"
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
