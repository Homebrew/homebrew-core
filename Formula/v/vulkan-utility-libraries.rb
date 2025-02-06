class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.307.tar.gz"
  sha256 "fc95ed875dddd96a58a4b1389f7b1acaf410b206e034529ac0187b9e42878513"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d9a148ff05365c0397a67d341ff6bb2caad0b6e811db64e1f0262033b46f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e285760fca1c53a10b555f68242675225ecfc969ba518de8326808f05fd7bfd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "711a47e56d01e884722f4d27b26973088468b1e5ca25ab48e932307cfcd0fa12"
    sha256 cellar: :any_skip_relocation, sonoma:        "65e37ab273bec079903dde5f9018d7659ca0789152972669d909a293687d7f60"
    sha256 cellar: :any_skip_relocation, ventura:       "bb5a49214f98f8ce567ce78a304d023c3890174879b0ed699e33ec13b3bc31dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f2890a961a01575e436f2d40866be084a937ad503ca3610d05f4063f84abc6"
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
