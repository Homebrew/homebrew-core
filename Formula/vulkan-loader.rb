class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.239.tar.gz"
  sha256 "dcdbe3f5362035ecc5ffce2140393de377038c44e00dfb8bae43816eec57dfc6"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "88446c67d93876bc53ff50ac49837d3f2f0de6a325cd07947e2b37cea6a758f2"
    sha256 arm64_monterey: "b379e41ec7fc9d925ea073229b284db7a3a76e420b2ec5f5a903f0fba88acd6e"
    sha256 arm64_big_sur:  "9f197cacb7238a6f3308756e4e2d8b37f023ffec873f94a1fb98e14f09fb19f6"
    sha256 ventura:        "cdc88f6a48b1387126a383cacfd2eb40b04ce3959ec293cd825845649d91e6b4"
    sha256 monterey:       "73a7c95492cbc780db07a26873f4e2b7f26f3200b54bc55ccaf6f535f83d25b0"
    sha256 big_sur:        "9ff617dacca6c5487ab7364bcc7f80dbd1412b2b2bd9986d24407100d2a96fd0"
    sha256 x86_64_linux:   "d7da9544e9275d3238201cefa72a5800f116ea0377c53d54ce353358c1925198"
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
