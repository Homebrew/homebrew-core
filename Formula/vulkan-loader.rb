class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.224.tar.gz"
  sha256 "702a974c460c668a9469a4614aed0b06602e5031154a67bc195429f4604bf51e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "56ae560d1d9d222cc2956a208ccb4cb9c01bf73374be0f7b72030fe9a9794592"
    sha256 arm64_big_sur:  "eb65e2b3f72fc88552def2a96b152a6eb510830e1a5f41101f87ad77436b50d5"
    sha256 monterey:       "7fbfedff89b541da123e72fbbf03c1814c5799daf5c343c24128e5a0f40dee1c"
    sha256 big_sur:        "9d1b0738e40c6bf45cfc7748a945ab36801fff7d50a5e66e736638bc7ea529dd"
    sha256 catalina:       "4d7d7e998410c01d073fd920817bc36a0f1099291c53a2b961fc8fe5c822739a"
    sha256 x86_64_linux:   "9f3486631c252f8f23c18d8eec22277edb5570dbae4021ca9383790fb7d23d2e"
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
