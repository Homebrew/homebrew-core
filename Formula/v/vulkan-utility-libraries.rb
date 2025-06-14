class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.318.tar.gz"
  sha256 "5a6371c7982f2a07b718d4e79e86a059f065793e85b4d597af8c96e1a2e766e5"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f35466c200291dc2c6c732da22de07064ee64eedea4b51af94b0bb6646b65db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850516c3155ca39cc565dbca6dc484e2a73c18fc9bf3927ae3988e5b9c5be4df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd341d3a0c26f7472c7037bb8bab57f64b4eff7f136ce05e2eb5583590ba8233"
    sha256 cellar: :any_skip_relocation, sequoia:       "f55761e50059bc98cb7f8b61c29738802059c8d38e412b06cc24b5520141677b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc892dbcba34815954c68bd9131fa4c7b4afe9106322642a96c44543333733a8"
    sha256 cellar: :any_skip_relocation, ventura:       "30862cb58a732ca5307b1e7e34d253c8e194250eba558cdf3c3878825e9eb5db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67704900021412207a7ab09599d67e48bb511e738ecfa2e7f0803e6a6fc2a942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "098b87d407229575a1076d926f05e9b999cb1a635cb33e06ce005ce08e9e4e8c"
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
