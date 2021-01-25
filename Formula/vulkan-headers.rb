class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.168.tar.gz"
  sha256 "ec6a69836a8cd413f89071a9b978d0547849192538550c706a8e560089d59cb2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e671eb554a8d31a6b6d0916225ace4c5731a5294fa6d612aeedfb4dea84de106" => :big_sur
    sha256 "844725484af065592d3310b4ed32eda9d3d926ff8db573a792cd4e00fe8e30d1" => :arm64_big_sur
    sha256 "539ed019b0ba6971e6ca158c054801339b93f04dafbfa153d3ff4125ccbffc59" => :catalina
    sha256 "0e6c6f05dcc0b4feea79f4f8f213844938877e7a88fa29650f2f97565f47ca28" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
