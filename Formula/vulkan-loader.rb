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
    sha256 arm64_monterey: "07e30b93c9227cef5f998060870db0803e0a18d85867132cc67dc23579edbe37"
    sha256 arm64_big_sur:  "830f4a3e1c20bf2872a4eccde3b40a6603dd17e904546c159b201116dd7ea13f"
    sha256 monterey:       "9ab294858ffbfabf0e4e03a6e7f9a99900b7c77cb778182dcfbdae0907cdb5a3"
    sha256 big_sur:        "c8e292fffb9bd5bd8982a8ed02a4be91f7b298b8c09a68e38621569cb7f01bf5"
    sha256 catalina:       "9fb0655cda3704b2c9ef884563ed7699945aec2fbb525c5daa3ebabf1977c826"
    sha256 x86_64_linux:   "5158aaa6aeda722db1c9e8b7fa4b4154dac5e82c9e3a88d5942d53fb138715d0"
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
