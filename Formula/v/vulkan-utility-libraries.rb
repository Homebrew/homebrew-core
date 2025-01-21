class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.305.tar.gz"
  sha256 "38a0b848ffe244c86162fd3d09506133057cc5341efc986f6289b2306061f891"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a166315b6df96e625c1a80d52c039f77d5633b994f916bc77b17a046444948f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf52356c6eb2974d8461ae2343a6e529c066a4de2fac84ad3d9c16278b8afebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbfca1871b89f75cc41bca629a29728149f6173b56c4cf3816d9d328d1be65b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ca291fb55845374b70b0809d3481f149ea21afdbec3c68645020941075ca1f"
    sha256 cellar: :any_skip_relocation, ventura:       "ef9b4c0b18fbf6c0ceb4cee60aa2f9fd335b5b21f7c14ead326e5a3be2733ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "399f109143dc5082dd72f239a42ac12f76b369b6b14fbc03cfb272c4b608c1c5"
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
