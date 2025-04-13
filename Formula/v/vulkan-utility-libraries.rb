class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.312.tar.gz"
  sha256 "b16b407565036e06baa384ff005c90e674e7fbf13d44844bd754199328d98123"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4134a6434f46c3d92076643d40324c124de1dc5d9a7427bb1e30f00f3198e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6648cdddda759b3316c4ca044e47485a4cc36f25a9f8796b40211c7da6336ec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48aee25ee85f2d6051ec0ba0e54c623334b2dd845dfa048b19fd8f7af8161248"
    sha256 cellar: :any_skip_relocation, sequoia:       "2c6bd77393eae588d2f1b7105a40de5e340ea2d7d4a4cda8def0e2df8e64bfec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f80f9e29ee21212e439b8bf67067a6e89ad87d75f65163303d7da26d298a7e16"
    sha256 cellar: :any_skip_relocation, ventura:       "d1e9a160ab69f20fd4e25157a1f680d95a32d334b43ee6c1b2c9b6e602f0d3a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75808fcd9949e8a43efc7674ee7ca3f25cef48ccd92c339d5d440982aee76b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b66ef0a0ea6b7ed34a534b7fb65d00411a0cb00885b0f0fdc9132544b69a0b"
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
