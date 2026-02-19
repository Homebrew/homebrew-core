class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.341.0.tar.gz"
  sha256 "4438cd451b51b5cd13de924bd9d5015c35a06a69e4423452edf79bad646f0469"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a174d54ac81ba158e6f0e515fcfa47678f71c3691b9b835c8568c4e45153df4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b503f2bafb01ac0cf5b21a0474e4863f04e77bd55251aa5970566d3d17627ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cf2e12b6ba39f0a2cd62e3fa896916de687e15971524388df13879c33e517bc"
    sha256 cellar: :any_skip_relocation, tahoe:         "087d30a74f7adc47c6ada5dfe03b5e264f0f492155312fca026d66a7889f5cad"
    sha256 cellar: :any_skip_relocation, sequoia:       "d0602aa33acdfa9dcedc604e8fb52ceea0b96ff1a7a55e53b02019a6e6ec3f49"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2975c57dd6d68a18eed40a52bfe157205f8283bf61bc49f95bfb94a9eac75b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5adc359916bc846855c5206782500fdc1d109e3d31275606c311eac1fdd8e244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b426fdbc4324524057a3f7a64e653a9f8dc80b09d00ee74e15c122737aa5b68a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
