class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.264.tar.gz"
  sha256 "080293761cf0278a257646f2a27c3d952090a0ac8d6156156c0558fe3a6ecdee"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64afbd6d38855377fe941db5f8fd4036e0c5a3cd6ac27c08b721d68e1f7a8121"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33bdfb1dc48a0bbf3f5004dc715bbd9c6f7f113fc7afe84322595b8bc724a3ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a0463bb8aea48ca96d5a1ae6806f1457b17478043d3263961a1ed7374b3dcdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1bc1e88e65b4bcf77e3d151ad5f7b9a292760cdf1cd969ad3bc3c3ab7cef937"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac7e3b28939e71cbd4113826586cb353062158ce3d71ee65b4b95689acd990ac"
    sha256 cellar: :any_skip_relocation, ventura:        "129b8f8994c11b2934d6488a8f4a460fa33cef32695e6bf578b3405622d346ad"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c9098f6563e3251eeff866c2250e14b7c92139bf96a1a4d09bc77a3c744aff"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ccdc9b5bfe200334d721b4a6dc047dc24887590e1bd8e3e3cb2204b3c78ee44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0aebfeff456759e2d6adff63eebf23db03cf532b54fd38d2fd7e605f97c3ee6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
