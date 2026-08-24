class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "6d450436aea4a821d7b0d8bb914c2e375088d98eeeaad0fbf059fdb06ac937f4"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94471c6f13d5310a54722988548bf7e6d6e180a9dfad4e5a9fc56b5477fff301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "416993ab91f7566844d89dcee2d93f9d623a44fd2da9bca6955ce079c7934edb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79593b613065834bc2a769256985e2a9f109a4252e967e61c391d8899f451fc6"
    sha256 cellar: :any_skip_relocation, tahoe:         "b32d19996abda2a6e7f5be4334580d8bee92c7e3c92af433c3e70676e5cde0c3"
    sha256 cellar: :any_skip_relocation, sequoia:       "5016c3da079f524df36a2140c07b458b472d7f70331e24b69db342ed2e3703c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d362da4a2fe8726ae7e1cae51ce41f3e63fa68b0f63d937fe8d1c618644a5d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ae819a6cf9427de418b41345d9d02e575b0d51a892eb5742c4516c41798bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184cc8c9ddc30e77a2dde83c301214e2855ccd796fc50658c9423e807fd1f702"
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
