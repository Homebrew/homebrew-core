class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.305.tar.gz"
  sha256 "1f2992538ee6a9d7ff3e00fdc8dc0c3a03a6235ebb2a1b7ee2179a13bc1c5c06"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "2d062061caf7ad594e3966062d07ffdc749020a1cfb7623cb623f5f3b4b6cdc6"
    sha256 arm64_sonoma:  "0cada862207fb6bf5c731b034f4a9d920e3976f64ae53d89151292014d3c03e3"
    sha256 arm64_ventura: "756a2083d132db3b9c631d50ee51f12cc88df27764a4c3a663d7de1b22743152"
    sha256 sonoma:        "6dd8b03182e63d7611911815d11db293e4211c2a25fb9e05e1d578f0092ecb86"
    sha256 ventura:       "971323df7bb87eab01049943e06466d49f8b3ce58e1d492ca8c2b0a645ed4b85"
    sha256 x86_64_linux:  "c9df89bc8e47f6d67d1f597ea26585d9c044176728a345f1245025228849897e"
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
