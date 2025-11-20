class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "65a2a063a8a33ff298848bb1e70deff8499f1ea8aa486feaa8b2f507d8e9989d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "82386db4f3ceedd82ec27991ea9cbb16c899101027a5f494612762aeafa044db"
    sha256               arm64_sequoia: "320f7371be1199e8188b680a5103ee449b9eb67e5e5072dd0874fa47ac6b7788"
    sha256               arm64_sonoma:  "97c25212bafe90fa308fa3d0c2e1e964eb599a3f1e51226f98ca733283d2ca7a"
    sha256 cellar: :any, tahoe:         "0d8b2c11565f9aa2b9b2fffeb78f16de1a87e625d01f7918835ea89e66532fb3"
    sha256 cellar: :any, sequoia:       "6277127f41c357628e526d438225de39a9959422676fa0b3fadaf16344a71be9"
    sha256 cellar: :any, sonoma:        "9118bc3d24a7f6bbe45f715404a9e2f151568eee2ffe7108cc274f23cb7c652c"
    sha256               arm64_linux:   "aeee57bdcd8a82e159fbc89f44f1764a1b13866f6b69ab76fe5024fcba6b0958"
    sha256               x86_64_linux:  "ea4f729e108aa515ed49b2f696f38ec09c0771932b753da5b75832769a170dd4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libxrandr" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DCMAKE_INSTALL_INCLUDEDIR=#{Formula["vulkan-headers"].include}",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end
