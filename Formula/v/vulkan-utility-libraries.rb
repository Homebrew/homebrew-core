class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.313.tar.gz"
  sha256 "c6422e4b7940ffb71475a3490fef5d2bf24d1206dbcc1486fe8c7151a537d268"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f08590a4638609dbbef687a5f1b834628d61a966b87b54024768ec5665b313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "988668f86925c62ee589f70194eec3e10d87567991c74930737bbf79ef05c772"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ef60a2883283f9991d19568bde901b18eca4249f661f39a835f48144aacf1fe"
    sha256 cellar: :any_skip_relocation, sequoia:       "6a00c1bbcb75c66005eba54bb006379f7136de93c14f002227564a877a26eabe"
    sha256 cellar: :any_skip_relocation, sonoma:        "421affd170e4b717fc896880e8cceaffe93cf3d7d236e35e0247259135f9aec7"
    sha256 cellar: :any_skip_relocation, ventura:       "f39d5c4533d310ab282f2059c712b2c0e475a555e42ca74a5b1444a85390148e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9971f1f517c5ace657c7434dbbfc44f61c4879964c8cbc079100b90e355a1d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bda715f3ce0a7b28a5ff0257e719aed40a6d208d51d9d615d558b569ce17eb9"
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
