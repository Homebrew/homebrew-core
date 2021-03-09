class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.172.tar.gz"
  sha256 "c69619ac2001ac62378a99c56ced14a53801fdc204efb2b1f787c83b47829319"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4b35fb19d804a714995f060732faa55cdb29894a5287447d00a1ef8e246430c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0f56063ca69c2eb5379a3942ec09f9c9a1445b369bae7c5489a4cee04ab1e20"
    sha256 cellar: :any_skip_relocation, catalina:      "559f31d35ba07e6e97cb32bc8778ac34458bb68f50aa7fcced70b960c2366649"
    sha256 cellar: :any_skip_relocation, mojave:        "75f28dc461283e2dd38ab03a9b6c1b7f0225682787fbf2eed8e71ee16dbc0fe4"
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
