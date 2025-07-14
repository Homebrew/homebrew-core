class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.320.tar.gz"
  sha256 "fb210bde874a4688b0fae98089c4d7cd4496c99bfae5d9aaa37b008f6b3a00d6"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eef01ae2c7fd0019169e7209769c39d57bee72dddcf3aa06ba9e6b154a1e4882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72eb87d5dbb4643c2c9bf585db99ddaf596b695ffee51c6439656dc415d09f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7229b1fe2e192207ef78576016199364626a5523f1a2b812ca5206d6516b7c24"
    sha256 cellar: :any_skip_relocation, sequoia:       "d9cfad0e5538a3c22b8cd538ccd7a4fc1d0a6f77b5e50c88c34d5e4ecf94b376"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0534329ab597183ab3180ce76d5b79e86a26c19700888cf569d2246824093f9"
    sha256 cellar: :any_skip_relocation, ventura:       "de6838052a702b014fa676362b85ef4bb767af069c318ef8c7ddb6ae5adf2bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8dcc3e71c38cb06521d77850f3cc19fd6645e28377cbc390aef5229a2790792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6cc5b964ad138d7fa089dd29718b42b84cbddfbd3e8dd9f3bc8364ea1bcee84"
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
