class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.176.tar.gz"
  sha256 "d77b033e74448341b42d1b6f2b380570e870b0443875f26c9e8a636f01ee6fe7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3bb94b28b142b247cc38278061fe9e889e7f3688ca7575d44278d89f764c2df"
    sha256 cellar: :any_skip_relocation, big_sur:       "11663ef50ac98a0919684171ae2ccc6260f91a10cfa003a7ef6c016a4f7447ef"
    sha256 cellar: :any_skip_relocation, catalina:      "503b924cc87af76eb47aead1f90ce986edd768b5394d9c67cf5beef1748bc658"
    sha256 cellar: :any_skip_relocation, mojave:        "a84be3e9cabde865b4ad5d1d725759f8f2e86c19d8d4311bca31baad6c9fc2dc"
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
