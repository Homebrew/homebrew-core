class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.179.tar.gz"
  sha256 "b659719ae08379be36022d545247cba50036827fdeec5ae1b30889d50f358459"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18280db7ad044f255de3f4809e7152c4e2107cf9ba0d603c6fb0ff6135890292"
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
