class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.240.tar.gz"
  sha256 "7ea479c22f70d453dd029503c2664733cd01f98948af1e483308ef721175cfc8"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "b23edd97c1ebe915dd235d0d0883f8b2327c27f5376c8a15932e10c597197660"
    sha256 arm64_monterey: "9c66701f3e15b3d13e87b4e2d99a925f44c93b17ccb79d5a8f9e1b0acb8a33fb"
    sha256 arm64_big_sur:  "e5d2bbbc390613a95fb5d2586aade1149559c9ac8d1f5e9aca8de48794633d04"
    sha256 ventura:        "c05f7924e476dae99dbc40f39c68fc2f795328922e4a4700b6e587ab1635d640"
    sha256 monterey:       "619bcaf36273310a12449021f2d730b0429ee139f515fbe948684542e69966d9"
    sha256 big_sur:        "d870bf35dc3c74e4ee4c5cb8c638abdb54311ff065e7f0dc43671f57e5b1a78e"
    sha256 x86_64_linux:   "6ae285d3472636d5e3c1f360ca3775766c9a9ec568921af40463c7c48fa2cf3f"
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
