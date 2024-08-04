class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.292.tar.gz"
  sha256 "195f9bf64cee33b4ae5940ca6eab165320540654c3a22cbd472ecad267de303a"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15029a52702d8d0f8415d9fe0b8dfddf212db59b2ce85ed8928dbc1cdd775f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c019d74336f0398dc45f52a305ff3b1ac54117a2383f9c57caa84b67d33e5dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35991db5d0e9af1dec9d3bdd327f54e019258a69849bbf008b90f459fffaf858"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d9c33d405024caed0a82f9757f36ac818cad040b348ab757ebca896a82e2499"
    sha256 cellar: :any_skip_relocation, ventura:        "8cf499771c72af578385f6310a0b77989971b68c7174933edd8b1e2d66c95052"
    sha256 cellar: :any_skip_relocation, monterey:       "3078b30dd4e147cf6426572e1e980591b50cabb91c23fdc3891601540b9fc8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b47b269922c838529378c225cc4fad73944f12d68ca3e5f8dcc0c2421eaf1b42"
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
