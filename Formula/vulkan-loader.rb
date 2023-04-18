class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.247.tar.gz"
  sha256 "1d0062e8cd78cb25140a784b50eee3b44f0be346c1a8d0c645e41394c2e56290"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "ee1a2c3b5e75a692f97d6785d64471ee656497e00c5de65e153db2e0822dca24"
    sha256 arm64_monterey: "ac2a00ad51f8cfbf36ecb86d701b94d3a5d1e8ffc34f4d925a003049c4dc5441"
    sha256 arm64_big_sur:  "1cf0a5e98cf4a83e9d70fa2373ccbbd77f93e2afbec4b49890236f5509ce3122"
    sha256 ventura:        "ab4a1ee5dbb8782ac83b41c290ce7f339f4185fca8d90cf3cac232fb40c74970"
    sha256 monterey:       "0869cadc329b527be9179c25022850ace60cc953d2d5a6ffd57893a255b63d38"
    sha256 big_sur:        "d4c6f08678f3a70bc977fcbe9b2d195084b89e18a792b925e315289e1e0b792e"
    sha256 x86_64_linux:   "e0afa37dd46c120440791aaaa7ae72ab4b70c11944596a52f754e1e0e115a5ed"
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
