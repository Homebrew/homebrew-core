class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.120.tar.gz"
  sha256 "6bbfc35c1a826930e22ff39a99175242e293522632011c1a7d6f0e2d509d82bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "13118ad8d079784e600a54d86d6e78375976158f8dbc75a8ae6de30a4c2c7acc" => :mojave
    sha256 "13118ad8d079784e600a54d86d6e78375976158f8dbc75a8ae6de30a4c2c7acc" => :high_sierra
    sha256 "0a2baf09b44d870ff9c8dbd7a3725d0876c70aa7f44f8fcffa9ece713121faa1" => :sierra
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
