class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.314.tar.gz"
  sha256 "aad807bfe8fe5b1a442204c9daf935be9e3b9973004b05e5df98ca94ea9f0882"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd71a1c9e5db2127b037da77c275f19ba3cf711fbde10225346fdde06d68708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ebe94328deaa4bdaf025e674528f047bdacd40a922d146a23da10f42d37aa25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c52966242dc8074c767c401b917b8515fe8973a552f40e643aa8d5fca3a704e"
    sha256 cellar: :any_skip_relocation, sequoia:       "b779012cf29931f9928dbcf413148c3f157c194012c07f9ad2f97f1ceb837798"
    sha256 cellar: :any_skip_relocation, sonoma:        "65bdef34d26851dedc836977ecd7b989d95a6bfcb10fd5cc04a4965166ff6886"
    sha256 cellar: :any_skip_relocation, ventura:       "0035e9a835a7ceea28f14f4e55a41daa1175e53d97bee9d1c578c0ed1f041d3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ef7d823f4f3e09cb280b8b02ddbcd6d6e1894af168d7e14eddda4a8a18ce4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a58f22985ef063169532a8f6484d776d8ef2273ffb2721b3ca7169189f9214"
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
