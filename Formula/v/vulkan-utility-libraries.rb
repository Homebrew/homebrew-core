class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.297.tar.gz"
  sha256 "0589a56c4f1bc9d08eafe2b9b0e5df895f55ba1000e00b5bc445d700b964c0f3"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c744c0e1a282dd9a7c087d7c50f443cd362eb6b5cbce13a33aa630f2e02cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0f4b6e6f8b78ed466bef23052614ce7d165e942e74066b502b9e7facc1bbcc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97d1c7aba532a9c2fa0bd0dd92f4d50979e039219c8bc82fc572357760976f52"
    sha256 cellar: :any_skip_relocation, sonoma:        "897eaad38e01e1f60b262ac7baab0972f8ec44be2c28a76532ed8f7af80fd5df"
    sha256 cellar: :any_skip_relocation, ventura:       "739ab7cfcd7da10a161e2e1e3dc706d1e1aaf9fcfff1c55c31c727bcce088599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e16e5ca9659dffb122fc427c81477db361c69444e5ec50d6bd290dac9a67295d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build
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
