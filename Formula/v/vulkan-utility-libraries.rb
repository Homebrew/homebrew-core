class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
  sha256 "a5308b62e3bac84cf45c4d7dd5b830aabace4847fdb71f4fd7db3be034c2bebf"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ce4f8956ef1835eea8fca571a7a4eec061060a59b1e22a25f689df4a78cbb32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66b533c7d8c986bbf5a74d86ab96a22da354a52abe890fb9a5116894a87b0a53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c1ff63fd0e47fb63489054680c18d75840a8b47dcfffbe8e9950391cdef4a0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "422b69eba9260039fa97b5d815bc771a918aa206b7ff4456e850f36f930329ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4a7811e71ef2a102cfd131225be6132c8fced5aa42de5b25b2b626e560069013"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "vulkan-headers"

  deny_network_access!

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
