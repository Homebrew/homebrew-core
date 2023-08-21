class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.261.tar.gz"
  sha256 "85d13004c81b032baf7cc4c2de0b2cb57072a86855d7ca7fc9a813621da275ba"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "0238beac030dd66e84edbc34df4f8e438bb7e9c76d3e0f5694668aab3ef7fdf3"
    sha256 arm64_monterey: "8d1ec8d92636cbbd807716004b4fd234b0d344b21d71712b7ca1485da0091e35"
    sha256 arm64_big_sur:  "6e956563bb0f2da079297e14db106c16f33704ce9b72f89509a7d72063443ea5"
    sha256 ventura:        "a92cc0620126b8ad42f617c34c990382773d0f3521b935dfbed62bfa58075a92"
    sha256 monterey:       "1c7f74caf60512a5a32ff71c8aa0272ffbd7f60dff4e08c9779da478f6362fbe"
    sha256 big_sur:        "212181b0f63c1728f678b43235688115587bfad9dbf601610ef01a9459e2de68"
    sha256 x86_64_linux:   "649a17ad304e099c0b10119ad5846478a9cb1dbb74fa6affb1ab816ee4b4a36e"
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
