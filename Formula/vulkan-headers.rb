class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.158.tar.gz"
  sha256 "53361271cfe274df8782e1e47bdc9e61b7af432ba30acbfe31723f9df2c257f3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2dcbf4327ae2cbb75c0047e4c28c5310ab8650f1281b67e7feedbe7184a2657" => :catalina
    sha256 "58e25de9c7a0170af6b65d232aa9db90a2c3a3dd14658f83224efe49f05731bc" => :mojave
    sha256 "67c10884ae0373450261e5ada7b068b15bcc2686d13d367c2be23b89752d43ef" => :high_sierra
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
