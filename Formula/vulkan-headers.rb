class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.194.tar.gz"
  sha256 "8700d4c88fc2cde245829135a316d68f854cf979e87db5504ee4c42f24023355"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1cca44ab892e9e6a4c9de1f9e33069ba96d2739c6e9d8a8a8c16e7b38914680"
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
