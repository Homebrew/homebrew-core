class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.321.0.tar.gz"
  sha256 "0cb3c19bc1ce3877a69fe00955597684fa7bde569eea633ac735e36dd959768e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a85c2aeb68e87dafbc5a605451b4505609c7016c7a93c09fe0e836a186fda74d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9fb7bdcdb85833797ac77f97d365f44c055aa6007ededd6d48004744840cc59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef214bd78a3a636ba553d6a5cc877ce93383a1206247005044ae8f8d3c6ebcf1"
    sha256 cellar: :any_skip_relocation, tahoe:         "372c7e5247e6bb51e240f7c7adb239d4df65d5a677c65852588e8731122895ab"
    sha256 cellar: :any_skip_relocation, sequoia:       "86814d05696e52c3040816dff9791c16cfebc8f56bbc0899c269eb2fbbe1ac94"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cac2b29c4eb8668deb8139b166ba7227b03e8f665ca50c0e848d8a7c54efdf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ebfebc41b83ee5a39ca679402a6b627b6ec57ec1bccf5153a61ecd5449f3a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7831b095f97bdbf4a9bcc997984a04f5f391fd54c4ee1c2368a818acae31c27d"
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
