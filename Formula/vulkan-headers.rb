class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.108.tar.gz"
  sha256 "22f1ea49067cc16635dbb33cc2eeb8358a48d4288b2e587784ba89d90c9ebfce"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd1b7c75ebfe5d4998cd88f8418b2cc94dc29ea6a2dbf9668461670606b219e9" => :mojave
    sha256 "dd1b7c75ebfe5d4998cd88f8418b2cc94dc29ea6a2dbf9668461670606b219e9" => :high_sierra
    sha256 "ae436d844e83fa3191c429995cb343bc9c03c442c8d0c73cfa48b78c8e323539" => :sierra
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
