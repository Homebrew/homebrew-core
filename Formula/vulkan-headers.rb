class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.125.tar.gz"
  sha256 "86ab443d94481c75a5d0e87c460d286aa718bf25d73dbab251b9d65dd1f87cef"

  bottle do
    cellar :any_skip_relocation
    sha256 "22722b1c99c98bda1e1bfcdb565449a2b0cb1a734d2ecfc3fe68d6804e5ed3e6" => :catalina
    sha256 "22722b1c99c98bda1e1bfcdb565449a2b0cb1a734d2ecfc3fe68d6804e5ed3e6" => :mojave
    sha256 "22722b1c99c98bda1e1bfcdb565449a2b0cb1a734d2ecfc3fe68d6804e5ed3e6" => :high_sierra
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
