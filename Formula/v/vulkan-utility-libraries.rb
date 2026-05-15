class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "19a215e9469df0749d7c1b389fc667a3f7e160f0b6da71000fadc30140494563"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e20994abdf3d247237dd5a6e4a66d544cce1c6479b7a8c088b28bd4de82a9c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2143cb868b2e6c5ca70c3555286dfcc086028c893d908966a6d37ae7aeae27d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f80ed385ef351f29a308f7f83a1dd8bd13b01750a40f943a71550ceeffd576"
    sha256 cellar: :any_skip_relocation, tahoe:         "af74d86c4cf2fdfd4ed89f47b3b4a8077b4c9de7969b677b1d19444b5b982308"
    sha256 cellar: :any_skip_relocation, sequoia:       "548028864c56c09dfbc16d8f1b10bf3c9f1eab1d78983c9884ba03469af7d18d"
    sha256 cellar: :any_skip_relocation, sonoma:        "70130fa9d864c9c882ca5bd8b795be4232781080e6ec39d69819a1296aabb468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f45efeeb999921a7301a6a382d3809ff68658b8a26d0608e4b2515a7198eef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7779639109f79d851cc2526e053ca3ca74a859938ea636a298c48cae6573ac9"
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
