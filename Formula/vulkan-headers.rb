class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.214.tar.gz"
  sha256 "4b16611b5f8e48a3e30a8e5a1bc149110bd5e1b3d49f79f3992d07e7e0627d1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "157b4413402f6351224be1d30e5bca10f8b776cc1bac60d32fddb62e1e83695d"
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
