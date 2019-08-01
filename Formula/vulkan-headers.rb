class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.117.tar.gz"
  sha256 "fae9fe671de4c7d1b3445fa1516215f57869207394cfa20f8162f2bf8bd8ab6d"

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
