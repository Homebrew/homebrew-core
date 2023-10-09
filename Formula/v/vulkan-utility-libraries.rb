class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.267.tar.gz"
  sha256 "06ab448cfbccc4b99d7c8eb74543cb36a6e36cc0eca9c511de9a3e27b1a03578"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f530b5807ee71641e9b8abebff6232197b06b48ddde171f759da085188dae482"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f648abe0bf4fd0b082450901a5e7df4cfd4822788cc239ae3a3768cfeca2f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a98c8c4defc9c6d7426ccc71d13a03a8dafbf626266faafebfedda27618ebe4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ac34b0dfd6b9faf758fd763a43763330b87ad8b3deafcbb13a64b9088e4a35a"
    sha256 cellar: :any_skip_relocation, ventura:        "4bc8c18c787f0aeb4a64e675f63886d16bc0b6fc28c5dc2ad7d673cc1e725533"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd38523b47def886e27a0668aba3ec65b41d96d7a16ee08f05b213a5e8f4446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca413bdc1cd4ed727f33ae9d83b6cdf116e393d7f68e26ba7370795567cfcd8"
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
        s.count = 1;

        printf("%s\\n", s.pLayerName);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system "./test"
  end
end
