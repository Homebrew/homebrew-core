class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.139.tar.gz"
  sha256 "1d12b73e6459b8c26a21a084a8a65b2edcdb79e6d892da96735d932424403456"

  bottle do
    cellar :any_skip_relocation
    sha256 "45b6a54a8e52a03a2884dc6d0e8dad4d2b6916488689286933f294f6f175b2d1" => :catalina
    sha256 "45b6a54a8e52a03a2884dc6d0e8dad4d2b6916488689286933f294f6f175b2d1" => :mojave
    sha256 "45b6a54a8e52a03a2884dc6d0e8dad4d2b6916488689286933f294f6f175b2d1" => :high_sierra
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
