class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.350.1.tar.gz"
  sha256 "e8eca1be31a658c9d0ca30951f2fc7912e4bb01502da64f8decdc71836241a6c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "704bd07db17c8623400c8fb9cee1d017d49b984008297eb493e8548d242852e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f202c695128d2b75c84027ce23f41d54852173791ec577f4a3ffabde0078a365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59e95b16b6af1a92c968b3ba6bf2c6e2f4500960e78027482d5dd970a130c3cd"
    sha256 cellar: :any_skip_relocation, tahoe:         "1ff6107ab70da90ea2dff8ded7afd898ed2120ab0611ff7bb4d91404c3915437"
    sha256 cellar: :any_skip_relocation, sequoia:       "5bde4eeee8048fe1c8591afbce5d92971c6bac417dd89c286ef00533d080e833"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aa80d11573fa57ab427985accec2967d353bcff5c5f973a27e7ce59a1eb0b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec71b0f8d0d980d55e49c5664294a1b8e01b6792c97a1140e096ce29947887d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f875f534f08c8b837fad36ac243c0f2a2a677ffa364eec0c08a4d918dd7a1ddc"
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
