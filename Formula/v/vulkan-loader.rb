class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.262.tar.gz"
  sha256 "3bbaa5ee64058a89949eb777de66ce94bfe3141892514172cfc9451c756802d5"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "93503b1d91cf4fa3f6d6ac671e2e207197a803c4504af22bc3365aef834ac2ec"
    sha256 arm64_monterey: "957f8d1883d2e39edddb0eebcb2ea01b2f92cf810591cec415091f167d333000"
    sha256 arm64_big_sur:  "0e7df2d586e45312713bacdde4eaa7d68f87260adb46df8b174ccc0278518970"
    sha256 ventura:        "5502eb42ee60bc1bf533ca27aadf09aceba8bbedd16c135f15b49111292dd2af"
    sha256 monterey:       "6310604bc88eedd69b3ad8dafa62e9db0211a798df6aaeba0f7ec407cc5c2ebd"
    sha256 big_sur:        "8b2e7e56cf06c9a42c930c126d80ecf2fde799219075bf7553f2ebf0f4518316"
    sha256 x86_64_linux:   "37d38ec525b1c6e0fca9ffa70d0e173961ef5093bd85c1858bd5608a5d0d9801"
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
