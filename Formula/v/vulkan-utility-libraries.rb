class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.299.tar.gz"
  sha256 "300c40cf23960672b9de4740fc454eed66c30b7a6314d59c02bdb29116728f83"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b69858641912a5cb5f8627042c91c6307c86ed8a482d3283515f40d9054fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97217951f97aa162e00851a7fe3e082eb9e5d75e616d68dfe746f29fc1e400b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d56184ea46160e9d6cd6737a64a214656fdf1fde9b6429bfd322030cdb93b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "874e818797c3f4f960be1e1de3db49b3c0ca7b7628e6d98f1bede5079b83e55e"
    sha256 cellar: :any_skip_relocation, ventura:       "b113a084adb7da278c293d510e70387310cd948f4811ab0f18b89eb219993182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99171a8f146ca2c814b1a134a6f279e49c3003a312ea0f2df8803158f7018aeb"
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
