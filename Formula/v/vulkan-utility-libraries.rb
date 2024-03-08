class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.280.tar.gz"
  sha256 "ef34cb7e7f446a49920217d9bb44449b3ed2ae615081b58a63ce52d5853fc3a2"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a75ef66216714aaea204052d94ab70037c84aafd9c05f5af153351868c91b2d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3a87322efeb07d09723178376372d8bb6ca3ecd869e63141cf66ee7b00dc539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2645e71d38e1f932c55fe4d9d65dd51dd4e245e80f2479de4182283f34f0d34f"
    sha256 cellar: :any_skip_relocation, sonoma:         "53d65c93fba98caff5f7b77132d9697f80eb701359f0463101b43efab448ca63"
    sha256 cellar: :any_skip_relocation, ventura:        "586abec045530224aad9ef975d37940a42a978ce1176f908d0f7583003e8d950"
    sha256 cellar: :any_skip_relocation, monterey:       "ad6ec3024f935b69ea4862338667818d26e6d2ba21c3f8e42770a738a1bd83aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03360ee60d22da47bd5115c6fc4d2ee42dcb6f3f55495c71390b056a00fafafd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
