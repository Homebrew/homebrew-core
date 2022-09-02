class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.226.tar.gz"
  sha256 "992d8c7c9f85ac9e8a261a448a50f0ae602ac17964c1b2550894fc128c037226"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "0befb81c300129b589d834f4611f077a27044158e3c7f4776c287a0e682375fc"
    sha256 arm64_big_sur:  "be1ea5546f880bcca575cd2f93da4b103bcb1ccb6ab4bbb0b24d86188da03917"
    sha256 monterey:       "6091c7da3047e6b3a05525e494163d33d3e89e202238caf3a8c2ca087d01627f"
    sha256 big_sur:        "6091f2d5bcdf21fa75583a92b22fe9f9a78acf4fe2ebbeac14f2ac4737ce6416"
    sha256 catalina:       "8248ef2165dbca39cff9fa295b1c00be35159c918cfc309bef50631e0981413a"
    sha256 x86_64_linux:   "7e3691f4f86ae05a1c9da2c62c515e29a5f86a7a07d439c2d6d360085fd5dffe"
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
