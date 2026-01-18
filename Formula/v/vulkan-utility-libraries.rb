class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.335.0.tar.gz"
  sha256 "df27b66cfabf7d890398274ffda16b89711d41647fc8e0e8bb419994457948f9"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e72bc869e29a83a5b8987b4708aa96f9caaa925371a5486f5a53e8d3ece632d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a1ec47c380a7abd888c3e10736119389a65a0093817bbd48ced592d775c89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c4d116804321205c9d2b13720c9bdedc68e4a2620c37b641c3be55a4aba0476"
    sha256 cellar: :any_skip_relocation, tahoe:         "91c1c02da5a153324e8da9a50fdb03000691a195c889b0f3bf9655ffa8e6388b"
    sha256 cellar: :any_skip_relocation, sequoia:       "1b26d3a3e755a922a63b1db5074173e7ca0af2b81e65da63bb17056ba29a60bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e3cb27750ae16a5a8e24299b8b5b300704180f3bb15105105539ee54ea5a1f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2a1b9ae186310c86f92ffa770f0e6fac879ddc8b3a95a7398fbe62cbfd7fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738886a36adc65a9afc63610e159b5e747c9aac5cb2b91336d705997964a46d8"
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
