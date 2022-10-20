class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.231.tar.gz"
  sha256 "02e185b939635167ea8f8815f8daab76af36923a3b995951fe6a5d3e25c55bf7"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "d04823c0040c278cfc8d45f1f2202195a436bfb423382636f90ee1b5c349d829"
    sha256 arm64_big_sur:  "e9635be13f9d8ef0fa53d956beaeaeadc42acec867ceb90954e84fcbec16b114"
    sha256 monterey:       "40f94cf2787bddce51c1d6c1f627dff68a762eee956bf8b2b3f6eddeee783e1d"
    sha256 big_sur:        "2f28e75fc0e87a2311942668f4c63987347b070c98dfa20bcbcde443433ffb17"
    sha256 catalina:       "0c5e41bfad73b02adbceb0bb2b67793c734b46ef3d8b90ba78f506382f5c0b2c"
    sha256 x86_64_linux:   "404a9e594269ab59f8973aa7b140aa7b4dd863d61c60ac2843f50724c1f3a7cc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
