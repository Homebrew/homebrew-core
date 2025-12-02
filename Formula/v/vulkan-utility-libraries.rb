class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "953ef4c2547b1611f90102f531f362bcfd6c76751eba2ae8c0f23b38947ef48d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7272e1c787ffb0f00312ba40c143589e6230517b984e6aa6574e091be5fc47bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "895f887dd77255fccb680a0f4f957644f4ce23b6102f32cdf8d26ff2053adb73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "709537ccf75df7acbd6cb24f2c709a9ab3d199ea235571fb39c5066d397c820e"
    sha256 cellar: :any_skip_relocation, tahoe:         "fd4c0422a15272ab5e7fe2b493b3e9ad2127bfcbb7a7c4a6d22322a243b2525a"
    sha256 cellar: :any_skip_relocation, sequoia:       "ba896c69ef0a020c7d6e575683751b5330095325e2aea1af54715ebe34aec733"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a3f70cbf3013ecdb445488cd458a7c8da36f4e2cf7f6104ae18352ebba75ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9939979badffed549bb95f773867a615145ffccf955dfbd44dbad1d91d56fa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f685274a3b294b29443b0a2adb9cf1583897f3713c2ad74a573a6645fe4ea1"
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
