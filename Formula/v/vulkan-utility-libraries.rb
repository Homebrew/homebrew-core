class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.293.tar.gz"
  sha256 "c983280edddd728ff57649bc8b6c912120d26019d95b032d7300233d981bbe21"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc63da74197364f28c64caeac9d3640f94e4bd363b4b84c46f72a8e754d3361e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff2c14c1e3b1bf645aa81ce82aed1e2cb2827cf08789b51e9d2defbeef049a3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c45e2c5d9e9a4e2cba73d96408af3cb6c4d2436695f7ac751a6105598a2f8698"
    sha256 cellar: :any_skip_relocation, sonoma:         "45d96aa0f4d0c803c107dee70613a5eb1da26c12c1f1e990caf673bcd11c1aad"
    sha256 cellar: :any_skip_relocation, ventura:        "06e4e20964a8d6256e06bb7752a01973bd23c61ee5544861b30fe0c69f4c1e2c"
    sha256 cellar: :any_skip_relocation, monterey:       "5737f1ef7957bf6a88a45666f2c123f58126861b9252f07a3839ad6adff762e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815a5fff40afd254d92245269cc0c4408ce9bf75d7e5db79d656bb5c5dbd496b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-headers"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/layer/vk_layer_settings.h>
      int main() {
        VkLayerSettingEXT s;
        s.pLayerName = "VK_LAYER_LUNARG_test";
        s.pSettingName = "test_setting";
        s.type = VK_LAYER_SETTING_TYPE_INT32_EXT;
        s.valueCount = 1;
        int vals[1] = {5};
        s.pValues = &vals;

        printf("%s\\n", s.pLayerName);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system "./test"
  end
end
