class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.226.tar.gz"
  sha256 "aa0059f516eaa4af327a2b08737ffb0f9503849836e0d60ac3aab183c3b1532b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "720c3f4a102e9cd634136df870734468a9057430a53b48d608fa38b6c8352103"
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
