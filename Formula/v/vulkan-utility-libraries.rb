class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.277.tar.gz"
  sha256 "ff09fb7e8cd963394b3b6d53032089c74da9bd4a19dd20e60693bab7a491eeb2"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc9d574e490bd84539f538af5a5dca66af2272a713dc7c7787cd8f2ecfa80ac1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad7d54903052a36cffd7372fcecd086b3469626ed0a17bc8cf5f3a4f4cfa3e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3ea951d19161b081c19563b322a0a6fd5a02566ce10ca64c105659105ed4caa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a7a6bd64b01875eaf1c641d67e4da248c3e4acb8bb9bea90cc356694d11430c"
    sha256 cellar: :any_skip_relocation, ventura:        "4b20a1aebbc61efa0bc5db3dc45521e746ccf2e93b47e2f3a5c615db161ddf66"
    sha256 cellar: :any_skip_relocation, monterey:       "ca3278c09a38d159a3fe8ca2b83c01a8f4c5b527604d4d434df700ebee318cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85c41912a8968f106f912b813f23d79d90e30d7eebda6c303659efeb3ae6984b"
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
