class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.132.tar.gz"
  sha256 "43700844234dea88c1adf07a14a4c077c240a29927b82e6a06f36a23ffe8d08b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddd5f5cbace8fe7649c6e3991a9b03a079217f290492a15d44455258325d09ce" => :catalina
    sha256 "ddd5f5cbace8fe7649c6e3991a9b03a079217f290492a15d44455258325d09ce" => :mojave
    sha256 "ddd5f5cbace8fe7649c6e3991a9b03a079217f290492a15d44455258325d09ce" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
