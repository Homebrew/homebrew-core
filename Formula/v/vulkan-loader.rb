class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.307.tar.gz"
  sha256 "661f7b7d1536538420771372dd8050f2d224fcf3a023f31d66ea76d8af7b911e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "61e1806948bfe1a3b36425fd9e12b27de04285ecf301129a440876c8c06ae064"
    sha256 arm64_sonoma:  "add925d96a00f0a4f356978fc2ecccd8f5025404b42d00b056b9ecd873f12ff7"
    sha256 arm64_ventura: "bc55dcf2c6012a92e68e95a48d1bedb376ebf06e16a975466d8a9da0ab7ab48b"
    sha256 sonoma:        "24cebd0621abff8e3ffd1a3c34550a85fd2d667be1f5541319f63bba0e4d6a46"
    sha256 ventura:       "754c2fcdcc3611b2e9740424e95399a3cf716b3d7ffb19c56b4987519da944d2"
    sha256 x86_64_linux:  "93b99437020c3f2d59ff16b1100bdffc0b98366ab3bf2518c40feb1e42eaa3d3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
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
