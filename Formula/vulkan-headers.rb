class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.111.tar.gz"
  sha256 "d693b5cd0504ee374f5c1541d0eb0252d84f35024b0eb3748f9e3ff8e1bbd481"

  bottle do
    cellar :any_skip_relocation
    sha256 "56f7d6795920a110016f067138d4d7d2d6830df3575a9a1da518c4e2045b8eaa" => :mojave
    sha256 "56f7d6795920a110016f067138d4d7d2d6830df3575a9a1da518c4e2045b8eaa" => :high_sierra
    sha256 "c385f9c1b9547fdc66e67500523902e0c0b50f5f37fabf6626bfcaf1ee0bcf63" => :sierra
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
