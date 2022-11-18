class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.235.tar.gz"
  sha256 "fca90d27e60816b5d72a700c241206c57e7d909e8ab4adfc340f5a5e9a019448"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43371dbe05188b4bb097477020d4fddf77422920d660b36a6105d9d3aa106a24"
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
