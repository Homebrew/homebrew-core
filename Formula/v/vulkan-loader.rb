class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.299.tar.gz"
  sha256 "32b268b140fa7a9eea46f25c83e0c86e5e9959dd85adea3807e332d0e19ce0f6"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "7a088df5b6a5c39fe6ccfe03bdba6b536e6cebed9e2d8ef0928d34a53b171d70"
    sha256 arm64_sonoma:  "e53bfdee03253da65a69d72336803f7616622f5338470ceea5fe136831e87c06"
    sha256 arm64_ventura: "73399cf7fe9c10ed48a46742efde7d87e1eb7e099441661090c9b82e377bc590"
    sha256 sonoma:        "eb13b698732799e7c0b026e45599d5ba89e0547adb38e36ba734e81174aff3ec"
    sha256 ventura:       "7af898ff68be9909563b88b93887feb7e353e8f4f2c5581c2b30fc26b015e347"
    sha256 x86_64_linux:  "334ae23d4c51e100c315f1973ef83848deea12a910ab754a8523efc6e9a1e42c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
