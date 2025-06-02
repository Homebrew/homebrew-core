class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.316.tar.gz"
  sha256 "3423b08cb1519e66b985c4f1edd07395fa3d61bf33fd50e392817ff229f395dd"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cefc6b5f095fbecdebc14bfdf6b548be5ff23b91ac185485cbbcfb0ba2cdf4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375fe3058e8c3afb43561bde60fb402fbd704628e4fc6b168f2ff725ccdd64e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311e45e944cef5d6fb02a2b00ab8f6f45eafa8973abd1742f13704f81cc20b1b"
    sha256 cellar: :any_skip_relocation, sequoia:       "16baba2b1e8cd90da3e2141c9059e5c3b8ae89f0b6c40dd77e305044d1e700db"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dc9ddf9a3a2570f4ecd52dd35ed1544c08be4cea44f27fa4c6ec4b17aa7990f"
    sha256 cellar: :any_skip_relocation, ventura:       "b17e72e01fad8e30e523049a6ea97afcdbac661e9859adac6c8e24d224edc4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8db0b6932dfe6d9fb57b7ac7f057ea70748d0fa4ae97b792acbab7b14863fd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "022c027f5ab38f34f0cc30a25e3ee470f9fba2668e9ab6b81e2054eae06feab0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-headers"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system "./test"
  end
end
