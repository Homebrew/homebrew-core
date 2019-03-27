class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.102.tar.gz"
  sha256 "5a1746eee17c59fc68501b6cceb6753e570ecee81e8358e17ec857666bc592fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbdb711e8a364ff0ead17497c5c5a46a0db8703cd37523e746bae958642fc6f0" => :mojave
    sha256 "dbdb711e8a364ff0ead17497c5c5a46a0db8703cd37523e746bae958642fc6f0" => :high_sierra
    sha256 "4ae594ef029dd21dda35b3a257b7c90340972fb97dec64b616a9512aa0e0542e" => :sierra
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
