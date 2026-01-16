class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.335.0.tar.gz"
  sha256 "e1d7f598d42fa87b38fd7e984968c660e406168db64df8e8e23c5be3a66e9bd8"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "8bea1ed56c73ff9b9ccd2729809a6b73e92f0f92f443c078c9b61d26d554d246"
    sha256               arm64_sequoia: "95c04390b7c74e48c46b85e42d05c0ca917afd7eddb4baa275c6486b385ff737"
    sha256               arm64_sonoma:  "0a3087f3e2777982210c6967f8bf8a485dedb95f351b58845638ed1e52f87665"
    sha256 cellar: :any, tahoe:         "c1e32933dc47f2f1c0338aa0cae87081190e26989ecae294de59822f337394cd"
    sha256 cellar: :any, sequoia:       "a82c7fc5b381237faaf0f48792f5d42d86fa92301da5595909b26ee629f0d3ea"
    sha256 cellar: :any, sonoma:        "af0213fb3c4690c37984bb17da75c4ea770fd922ae5392fec384804d73f54ab4"
    sha256               arm64_linux:   "1b21769480ef54ba3528b0292850177e96ee985f6b6716849da731231c73ca26"
    sha256               x86_64_linux:  "45cc952cc5a793808df5bb2c4533e538938549856d07789ae7aee17c32888f46"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
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
