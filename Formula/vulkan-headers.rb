class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.209.tar.gz"
  sha256 "345011af2369963ef65eff2f678419efca728a3035741882d52f871bbd3575bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc4a29bf1828c10486b3e519d03fc59d078e83faf7a2062cd7af23a3c1945279"
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
