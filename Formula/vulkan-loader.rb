class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.220.tar.gz"
  sha256 "fe5b65e5d88febb1220ae59de363ed8b2794f8c861d6d74efb14aecefd464559"
  license "Apache-2.0"
  revision 1
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ab0bccbca8a0bc1dbe9f49f4b54fdce5726b76c41e19ed4e4e867459fd96d070"
    sha256 cellar: :any,                 arm64_big_sur:  "a489c1ff5781c18ae2a90e0ebd922151d01338ed247dba4b6236b7574c26eec9"
    sha256 cellar: :any,                 monterey:       "e4d6e3a2cce6ff2a33f89ec6d9621fa0d6614f4d80e64d9efece1cbeb81b1d46"
    sha256 cellar: :any,                 big_sur:        "4dd387063eafe4ac4065d029e58f3df930a322afe91364615fe114ce94690d21"
    sha256 cellar: :any,                 catalina:       "3dc34d81d643d0268a73513eb43d58f70ff2e6d99fe429123df9832fa686faa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d621cd906f1224d4940e6a7d2c4b14d0789514b89e820d71651e1a7ff5d6933f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxrandr" => :build
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
