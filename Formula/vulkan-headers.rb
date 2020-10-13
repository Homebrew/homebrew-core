class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.157.tar.gz"
  sha256 "dbc121f58641acd45c386ee96ecd5e10a124c489087443d7367fff4b53b49283"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdb764b9af98dfa1451e186f2923340db863b0e7e36ada87b72e38a9e7972009" => :catalina
    sha256 "271699f601bc77de5846f9280f7b7519eb55c1661ce34ebf010cbae2d217ab1e" => :mojave
    sha256 "4715d40056b8e43b916c1e09dc4f35e870232918546709923f515913c869f829" => :high_sierra
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
