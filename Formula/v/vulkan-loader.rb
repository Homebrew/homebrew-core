class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.314.tar.gz"
  sha256 "0ab4147003b881df01eec1cceabe3a2e1491dd45bf90bb50113f791af6b8d86c"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "596c8bd8f28488df4bb06d56ad5a691dbf73926d3f124649591b978792acfcc4"
    sha256 arm64_sonoma:  "2c125f1610a562a89e23bf99fadc32f0bbe428ab51dd964ad946a53c697778c0"
    sha256 arm64_ventura: "aa4c386986fbf9b82f1311d2bd1089c0f3af0441947583bd53579c5aa5974c0c"
    sha256 sequoia:       "e2ba1fccc5b2c19389e2e575c12de4403bcf3e4122f1714ca9403d4a00ffbdb1"
    sha256 sonoma:        "27868e1b2db58f4f6d4c466ba1ebc3e9763ae71ade76f8c743c14e97d1330e17"
    sha256 ventura:       "67d829de9eee5eab2d9ec2c4aa2e04e19c3424777e049f1873ff6bdce8059e29"
    sha256 arm64_linux:   "12ec33a2f9c8c722b4856c540b937bc0ef3ca43e2ccba0f6ee786b8c117e5f93"
    sha256 x86_64_linux:  "c921ea0a86444bfd4dfae863b5584d6ac8bb7f7b6aae40de98aafc761ac5f08e"
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
