class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.151.tar.gz"
  sha256 "9a3bb3077c9bb71347d6b9942fa5b728053b67dbd5c1eb9d75a774bccefa18d8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7154de12899e81bbb3b3da962b5bdafdc7e450fa457e4c1df45b20b31629365f" => :catalina
    sha256 "7154de12899e81bbb3b3da962b5bdafdc7e450fa457e4c1df45b20b31629365f" => :mojave
    sha256 "7154de12899e81bbb3b3da962b5bdafdc7e450fa457e4c1df45b20b31629365f" => :high_sierra
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
