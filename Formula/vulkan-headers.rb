class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.169.tar.gz"
  sha256 "e1acfa36056a2fa73ddc01bdac416d0188c880161e2073bbd5a86c8fbbc9bdbf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "270a75950ff4d136b845fab2e871d9b0773dc186c4baff0ac4396a37871b3443"
    sha256 cellar: :any_skip_relocation, big_sur:       "3444e99900fe60ef08a2b4e7a16d627c5982e1b867b7bda9f249b87fb3d3e889"
    sha256 cellar: :any_skip_relocation, catalina:      "df9430026aa7fee3edee38d7e2097e1eea8aeb2f2d9d5f60556139478a7acbb1"
    sha256 cellar: :any_skip_relocation, mojave:        "f2a3ab120c0ee50ac6feee00edae3a1c13819f0fb456bd4b16b666cf2ec7e451"
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
