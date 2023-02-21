class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.241.tar.gz"
  sha256 "c107034a5ee958f912d5a234fd11f7e6b28bf227b51c8f12f3eee633351c1d70"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "abce63bed67a2b13c9a04d5b0384c5f09aba7cc2623d7fd89d480c0424970af7"
    sha256 arm64_monterey: "193e471f04ef9f5f1e96fc3352e80102cb404639553cb4f3ff434e852723d284"
    sha256 arm64_big_sur:  "c610aea3aefa403e9e5cd37b42b41d0c3b2d8839612671477c90df0eb8aa7776"
    sha256 ventura:        "ab388b9a7dbc6b0854070320b5b92c1409cf2fd67139df39e5b26a47a354a8c3"
    sha256 monterey:       "78a6a3889712e4c25649836ae5b43bb3410ddffbd8f9d1ff0d82b1c8e73310ec"
    sha256 big_sur:        "3204256ef6444b4640d921c347d6339a7ca124bc86ebff2bf224502b6c9045db"
    sha256 x86_64_linux:   "669f19d1d70c04ffa844e68e6a320aa5b19ed4a0b59d522b5715edd5f656968b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libxrandr" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace lib/"pkgconfig/vulkan.pc", /^Cflags: .*/, "Cflags: -I#{Formula["vulkan-headers"].opt_include}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end
