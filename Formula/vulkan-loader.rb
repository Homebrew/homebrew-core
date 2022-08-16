class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.224.tar.gz"
  sha256 "702a974c460c668a9469a4614aed0b06602e5031154a67bc195429f4604bf51e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "7147a78644f277fc09a60789110a45a6ad90eb7f61db88a28b55f75f47b1c72a"
    sha256 arm64_big_sur:  "ef77b8ec5cc86fd233f0c46c1af787e950a2ed809098421c81ed3dd855ab77d3"
    sha256 monterey:       "d6775ce13f54113ca695edc611538e8c434cbd09b9d35a56eafeb506a301c700"
    sha256 big_sur:        "50a15dff1a16d354c6f014b09b6e10c8c55ea838c5b0b69fab112a8ac5402865"
    sha256 catalina:       "739e662c27e90b0a785342366d3135eb0dec817c25dd26508a9b5f37a11b8c15"
    sha256 x86_64_linux:   "82d5ef4c2016f6fa012b27f7dfbf0f5f82942b48f4c5d9319b3d45d444583557"
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
