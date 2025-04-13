class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.312.tar.gz"
  sha256 "aff1a255bc32e6500e6a435d0c331fde268b823da3888f549af97ee226fa9530"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "64f4dc9ef0e72a0ae9291398a24216ff710dba8efca44e1736e6728b962b70ba"
    sha256 arm64_sonoma:  "19080b88ec4476c97db7618a6b2e5ecb17263ad8a5243f13933794ecf1a59f4d"
    sha256 arm64_ventura: "0d72465ce25eeee629466df786a504b0651d6c551429f7a74a2046e1d187c28e"
    sha256 sequoia:       "eae3a6295c26bf754e6e25d5ed11d30436a48cc2b432c616530d584fb6121a66"
    sha256 sonoma:        "062ec15575ae670f8269452ef7b5bf5ef615bf8a30358f1688f4c5c2968fe7ff"
    sha256 ventura:       "fcbeee954083e9cab018a9cbe0fe6e47c1d8a7ea454ac6cfa58d7ba7f047cb0b"
    sha256 arm64_linux:   "1d09862de20b01d521c39f21a66d1f2e7a01ef2e528b727e220f39e482764bf3"
    sha256 x86_64_linux:  "31684c497f63be6f43a5c9f2ee9e1788e0bb69cbd3e04a9293426d8ba1aa419e"
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
