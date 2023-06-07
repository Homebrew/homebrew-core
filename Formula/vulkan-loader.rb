class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.250.tar.gz"
  sha256 "4e4bf5bb93a43686d36218309804d21be6070d344ccd0c73cf695cb66a1e352b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "91cc1362d8456a2dcd52603e98f4d9527daed39434ac49d647139f3e9570552a"
    sha256 arm64_monterey: "7db0638ef6549c76b7181c98f2a8b43f2d4c1884bacec2269e967ae7287edb8c"
    sha256 arm64_big_sur:  "560601f655ec48fc462c96b359c71a0dc0a5e8fd16f13e7131f6057ccb06a867"
    sha256 ventura:        "c9ff98573cf0983c796307eebc2565f2ddf97e54bdd8e792a7ea98f90d2583ae"
    sha256 monterey:       "df793743c2cdf7f4b59290e1860247e747959963cf04a709aa8f60744945923d"
    sha256 big_sur:        "f6b180c4afdd171a32697695ef6bd4625445dcc39fedf6d6fd3bbb1485240746"
    sha256 x86_64_linux:   "2937e79bcd0afd60a298ef5ffc62afb30369ff96d07ca08f5daf19fff682e1ec"
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
