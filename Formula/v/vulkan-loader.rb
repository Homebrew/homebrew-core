class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.313.tar.gz"
  sha256 "5e1917fe5681fa405e63b70d4a27f48aa9c37e3ed820649d998f3d6ee12f4f2c"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "21521b57c58666da7230393e41d424baf8afbb1422432cafa431875bf5aa9595"
    sha256 arm64_sonoma:  "109c364961781429bd3d8e58977a89b4aea03c07bd3502122536ef79c5528c1e"
    sha256 arm64_ventura: "9cd91e170e430e6b5d3cd6d9dc23db7710be160d8fb03786d75287d75836fd13"
    sha256 sequoia:       "10dddfd84dc5d6f6813ad5862c5c14bd9132b8b03a564dfda17d85fd6c5f5383"
    sha256 sonoma:        "7bf34853c2d1dba5c6a0a6040b85b05718c524469479d7a05ce71fab4caa642c"
    sha256 ventura:       "f274f294835c68bb7422e457e646194519eed594bc0cba1aba90e69956e45e28"
    sha256 arm64_linux:   "5d59298d8b719a4847c3024797b1abcd14d1c8af2a19a78b530ffbb07afacdb2"
    sha256 x86_64_linux:  "81726f95b47101d3fd23244c5c56393e49226a29ece4993e0442a5c4efc56f73"
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
