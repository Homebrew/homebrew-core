class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.316.tar.gz"
  sha256 "00e9cb5a49e48d7a81a32351c04866468c40966dfdf6393570953a30c41f6dce"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "5f9f25fceb0b5a71ac1459fa4d59e9fae3da7c9a1149c6283b962e38f103d0a7"
    sha256 arm64_sonoma:  "8ad5fbbbbb7a20569a2f50f7d32362885aec841f5fd5da1717a10640ec0ade5a"
    sha256 arm64_ventura: "982fddfb551b579240c8763acf3d06bf8b91de608e368b3cd1dcb4921fd39b5a"
    sha256 sequoia:       "d3d4868c831710909b841b241d8899aa49b90bacb78e589c3dfee6bd6f57b5b4"
    sha256 sonoma:        "657bf41803159039604f556ec94f05b0ae6127aa88cf2b28f09603a5cdab0de3"
    sha256 ventura:       "706cf991ac7d5ea92b727aafc5a7e86ed23abc0f18f2bb3aee6b17a24bb2fbbc"
    sha256 arm64_linux:   "3d9ca89f96019ff543843708c012a36afab6fc4dccd00e3ec0a5d084be6f50b7"
    sha256 x86_64_linux:  "736b13b8a92773eb5b2ad88dc6dfb47f578b01837bd6fbbe696e1a4da37ef9d0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    (testpath/"test.c").write <<~C
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end
