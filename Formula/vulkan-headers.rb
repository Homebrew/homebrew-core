class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.163.tar.gz"
  sha256 "68adb4739aaea4c6da7e4d2050956b3902e9cf3c5b1efbb590294fb2cb506fec"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a681ec81986f56b41126bf2c89ae1c56199741ff22f236de0299b7f1d416786e" => :big_sur
    sha256 "a9f3fd586911d3ec1e9f4598d89541b7228f3685d624de97c91fff8583c483b3" => :catalina
    sha256 "9f855a3a57876a7e9e617caab5338f9ed508b01790c2bfde54b63ef8c9d1f4c8" => :mojave
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
