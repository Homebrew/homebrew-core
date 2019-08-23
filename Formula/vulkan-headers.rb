class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.120.tar.gz"
  sha256 "6bbfc35c1a826930e22ff39a99175242e293522632011c1a7d6f0e2d509d82bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8053f8eade915e4a55726481d02ab078b4c3015b1dc1580e5c10bd4ad38a248" => :mojave
    sha256 "e8053f8eade915e4a55726481d02ab078b4c3015b1dc1580e5c10bd4ad38a248" => :high_sierra
    sha256 "31235b912c10762f1881a8671f899c458e17aa39d4dbd49b087d517b784e40fb" => :sierra
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
