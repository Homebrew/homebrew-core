class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.268.tar.gz"
  sha256 "bddabbf8ebbbd38bdb58dfb50fbd94dbd84b8c39c34045e13c9ad46bd3cae167"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5ce6fae4be15f7c97c252204ac1508e3d66cfa2cab74d7b01d577d1927f2a7a4"
    sha256 arm64_ventura:  "73379bfb34775398258402de37790e7d1482fd5334948ef4a028f390451a43f5"
    sha256 arm64_monterey: "c64224bc189b95d379f20c5abb33b95c10cf45a661b54ac2d894e98aa2c5a0a6"
    sha256 sonoma:         "7530b01f307398b49fdd0f9549aad54840e1fe48ed8db6e5a51b457af3d0e73c"
    sha256 ventura:        "c5a24fc6fb6dacdbde789dd99ae47eb1f0346de4e09b3c035bf1d97167821b15"
    sha256 monterey:       "088afd172f9b19d06e62b7685ec8b87b3d86464bc4cf667c72fe00a8c2bdaefe"
    sha256 x86_64_linux:   "348af431791370c56fa91796317d237716f071043e16815eeb651512fcb02f40"
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
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
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
