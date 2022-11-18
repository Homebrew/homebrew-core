class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.235.tar.gz"
  sha256 "948407ba3662801b87bae170db2ed1a7aebe900bb66405be7d301bf656140595"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "8271bcbdef6a0cd334bdc813d162a0b7bc1f9b2dca881d0d10d728db686f5cf7"
    sha256 arm64_monterey: "bd5f106da91c4ee28c7aaf710cf361a2d1b8ead84704680c8cf8592b43767d73"
    sha256 arm64_big_sur:  "138d24db1c3ca41b7d155ea37470dde78740d70ee04ba6aa2b05b1d8537ffddf"
    sha256 ventura:        "b444a3d32cf41ff54687bd3f285cc315fdf368a67a6abaea20d2514cd8e951e1"
    sha256 monterey:       "322a7d752d3d5130a995e7ea862e91f54153c2fef3223291261ea0f442b3f177"
    sha256 big_sur:        "369de3caf265df4343642b59dd539560660a4f12149e7ccbcd8714341054bd29"
    sha256 catalina:       "d8dfc11a9aa24645578b9e751fee1b3d16008ea4a15ef8d9f327b3ecbec552b9"
    sha256 x86_64_linux:   "b7de7afd5b81190ba3107afced4a15381d39af5f4a092ab264377f229d5de002"
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
