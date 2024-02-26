class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.278.tar.gz"
  sha256 "d2e01241b11042f90868e72f911d7ef92962af2c174db3e7bc780f0cfabf2bef"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "189dd505a8ac5e2dbea8b903fb8d2d922f0ced233b676c0004d9b2c859b06de4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f1782ed59e0405604b05c15e3e1f13c08ee848332236f72e4ca0b40fa0f80c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f6b12094b63c7c94eb075bb786ce22f0902f130b197d0022c84fce9b11a758"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d720e63316332a9e284849ecae671c7d1f34a32119362c2a91fd8f8750791c4"
    sha256 cellar: :any_skip_relocation, ventura:        "8ed784f0fcff4f285331af06b77ee023baa048ab0a153b68aa000e234a8fa85d"
    sha256 cellar: :any_skip_relocation, monterey:       "929ae2399ba8238a385fa787d1262e02bc6f9fbd06f00b237b54f5937ddd5548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1625b47747044339bd9d41c2c0e30713e1aa0ced9819ddd613288df716b4d80a"
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
