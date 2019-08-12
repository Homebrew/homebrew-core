class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.119.tar.gz"
  sha256 "85e012c3d6a6e8b54203cb214f5b737d9ce032e3a64e9bf5816a5a59ca0f6d6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e9816dfc20a5981323c37357614083a636584d69fe4a39a8c95f8e0bd064040" => :mojave
    sha256 "9e9816dfc20a5981323c37357614083a636584d69fe4a39a8c95f8e0bd064040" => :high_sierra
    sha256 "c53dbf2e014b68cf69d108c7d0e2b6adefb64147bebc205665d8c76a68b00542" => :sierra
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
