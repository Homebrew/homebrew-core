class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.217.tar.gz"
  sha256 "004b4f7841bd912d1cc3f5ac5694d5dea2f944f10053451233b533874368df87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9a2f456773d310551597dd199a6001624c4c985d3341af05b8b553dcd655e25"
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
