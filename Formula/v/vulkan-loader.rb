class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.277.tar.gz"
  sha256 "066d866278b210b6809398083cad143c9c6df9858bd15bd614f95cde7d4a560d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2a9904712d9f1f0a5d236a91a971f4ff447da7f8c83a5d80346533bcdd22e44a"
    sha256 arm64_ventura:  "bf895c8fbd181e53ead6de1e794edca93c6b13cd70b53a67003696a9773afc2f"
    sha256 arm64_monterey: "ccb1f364ed9bfd988e08bd4789123cd5fb9cc98733aee58fc446f54a2fedc177"
    sha256 sonoma:         "02248f70e9c160ef9d478ad646a1ee62e5094659db6800e7696ccf234f847b3c"
    sha256 ventura:        "9eef82a8d079feea7fb06d6ddb2beac3c492e729787849df6ed5acc56c76704a"
    sha256 monterey:       "5b80e6d5db312ccb0962deedd1e78e1b4a201f997cca2a2522f2b236a5e5d28d"
    sha256 x86_64_linux:   "22d72c55e4c825907059646c919dc297aa508e25515fa944b951db0357d2ffa3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
