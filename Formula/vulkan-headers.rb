class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.243.tar.gz"
  sha256 "76c57490740369a26d68dd26d308e2faa2e0fc5d255498aa48ee389534fc5a48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62e898f956e5a6d7ce48b705ed62796a32dac92045a507ff8974a436f3782055"
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
