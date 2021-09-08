class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.191.tar.gz"
  sha256 "ff7c66144df271eeb5dec9ba6cd3773236b8d3a04df4bc55cc45a95e30287371"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6a369d5f884dbf1e6da28fd0741fe661b5110c3427b78f97bf1118f43df0a0a"
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
