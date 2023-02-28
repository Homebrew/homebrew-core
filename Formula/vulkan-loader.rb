class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.242.tar.gz"
  sha256 "b148796d2aa5c8e655072ba985c968eed65d91f8d4fb8146919c3577bf725bee"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "dbae5bc95eeb33607e8616620d2da0b619dc416e7efe99961c9a867948882b9e"
    sha256 arm64_monterey: "6d666d69ab4619f57ec30e8f620e157281f29c197ffc71c16b8b876091fb0438"
    sha256 arm64_big_sur:  "98b21d1675fcb9d6ed0be1c34d0222d4ff58bf6bc2f14e9d79c45f9e810845df"
    sha256 ventura:        "568d2c5b878e5ddf900516ae8d42bd50fa5939113353ce82cc0c39da6ae4c082"
    sha256 monterey:       "cf776f0ef5a0ee28fec169f7c368684f3335685f1a9498469df810b5591db80e"
    sha256 big_sur:        "01991b0eba636bb6c0a69f93bfdbdf7ebba8cb0a1d4f50e34dabbbb17387dc49"
    sha256 x86_64_linux:   "39bf751d408387a49a44500c0ddf686748cbf20540cb136d2227cdced0fc346d"
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
