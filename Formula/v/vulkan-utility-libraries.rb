class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.262.tar.gz"
  sha256 "2057fbb6dacdda660c5f1d376f7e2217507401a6d1c83ed11a3c1cdd694e9d16"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build

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
        s.count = 1;

        printf("%s\\n", s.pLayerName);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system "./test"
  end
end
