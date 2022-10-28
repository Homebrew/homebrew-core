class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.232.tar.gz"
  sha256 "b2eedd01c22bc42ea269fa10a2af7e480d7b0f35df4d821c76dda3444229419f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e7d7895f29aab9b79ff2afb040aafc1179b1f979253bf399d0cf62509e187c6"
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
