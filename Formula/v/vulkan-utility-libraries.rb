class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.268.tar.gz"
  sha256 "990de84b66094b647ae420ba13356b79d69e1c6f95532f40466457d51a9d127d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d236757226d30eb6583d11a096ce93956c47a6cf41ff08d79af48a87cc3ebe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aee46fbebd19c1ce7c2c1aab498466c52cc8da2be8883a15d36d7129d814032b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba43b730a473a025af5be40fbfee08074fdf08773686016f4ced9b6c5c3eb0a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b4e2413d7b1845895666c22a1e5c96c1a4d9f910edb00c8bf0bcbf5c50ffdf8"
    sha256 cellar: :any_skip_relocation, ventura:        "dfa2968735fd23fe8b24bb00a6ee998741e2c26da0b313015a9148557874f56e"
    sha256 cellar: :any_skip_relocation, monterey:       "51661f5a0e2295f4580238a57b174a6837a563f4ff368411e5c6dcea7927e6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9841e2b776b139075c4468e269bedac2f0fd01c6dd90f5090a37d88f9d515ae0"
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
