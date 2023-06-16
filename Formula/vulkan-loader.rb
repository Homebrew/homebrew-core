class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.253.tar.gz"
  sha256 "9ab9305f9120e6867cbeba1553a244b5096e8a950a0efa3fc68bc66417e96a7f"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "3a574179a76f75d93afbe001af8b935ce02bce699ce488b4cc56ed10be575629"
    sha256 arm64_monterey: "9ff6c19e5e108aea6c183387965f346fd2c4367f4ad51bd0e107e3a2796b69b2"
    sha256 arm64_big_sur:  "a34f208818b38677a885f208dd91b2ddc796e5f2139f3afdd76bd6fc10225a17"
    sha256 ventura:        "c7f0471cce2e38c11287a394ab4a1a02930956732568286908845a5f27bb2f39"
    sha256 monterey:       "ba37c19b24ff781db04229ce54970b6cd393dde3198910e23435b0c5caed0820"
    sha256 big_sur:        "2b8cebf9544201282cc1aaf5ccb173ce41f815af2ff88394881732f624a430ed"
    sha256 x86_64_linux:   "827879739125dd027473ea8943000adc5a49b628b4502ecb559d3c6620b02ae8"
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
