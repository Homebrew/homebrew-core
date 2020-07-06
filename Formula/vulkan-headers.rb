class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.146.tar.gz"
  sha256 "2b068692cedf549274bb6a314499d14a2a84ff83560cb26983c21c7e2422c253"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "966886b67f7e069c87bf960dbc979e026df0ea6f54097faa4e3c803d4be303c6" => :catalina
    sha256 "966886b67f7e069c87bf960dbc979e026df0ea6f54097faa4e3c803d4be303c6" => :mojave
    sha256 "966886b67f7e069c87bf960dbc979e026df0ea6f54097faa4e3c803d4be303c6" => :high_sierra
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
