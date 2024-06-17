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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c48b4f6d41adac96708c4193f0db91c627290e284508e7f2230a99fda22cc096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf9c042798385dbf74db24e86483d2650dcdd2454eaa3ddeec7fc7afb9ba435"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af6cece2a1a9eb10f0efdbdf8de093e22ffcc5e9794423da09adfa8065cb92fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c56eda853323f4e30e62f59ec0d51a087d99ae89f502f8daf8ae39f42982d27d"
    sha256 cellar: :any_skip_relocation, ventura:        "14a5184af893e9ec42a5f40fc5b78a2a0f4ff728d423654fa4daa1c57e4c2611"
    sha256 cellar: :any_skip_relocation, monterey:       "cdb194aa698b744b0a4d43937077e07290c1e966416709e405d939bbff16bec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9682480d8655391c40edd11aa8af690b561d4ffb1ef08c58f405bf2abccefb65"
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
