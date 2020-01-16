class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.131.tar.gz"
  sha256 "f37ad7db549af224f30c42874d7dc2544905977851517b05d30c385f6e4b916e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef367ba95ca48295e6aa324f9a1a9c54062f47f372c0985c35c0162c4ad5a1ae" => :catalina
    sha256 "ef367ba95ca48295e6aa324f9a1a9c54062f47f372c0985c35c0162c4ad5a1ae" => :mojave
    sha256 "ef367ba95ca48295e6aa324f9a1a9c54062f47f372c0985c35c0162c4ad5a1ae" => :high_sierra
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
