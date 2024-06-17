class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.280.tar.gz"
  sha256 "eb0d9cae11b06eb7d306605b97bfefcd31d40def97c7617c765f73f7535e3853"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "90735da41b552351e5f41710602c9c38237f87aeaa29b28973ff5e1b86924492"
    sha256 arm64_ventura:  "ed71ee7fc504c9508de3d6220d411e517ddef0ce67cef140f5c240617ecfe6a5"
    sha256 arm64_monterey: "2a85311f18331eec45845b3a3a999b085ef80e4e5059b4a2368c12a5714c2fa6"
    sha256 sonoma:         "efad0a14b534bc0e9ac88c9f3b70e5d169a3d8fd934ba56c70a2e737b60cdd5e"
    sha256 ventura:        "0b11348e5aaf35d85bcb35a2ace6fc4e447621208ca4fff3fdb99bf52cc735a1"
    sha256 monterey:       "3793bb2000ccbffee59c3cad05d4c87e407599a5ed198f994b5cafacfeffed23"
    sha256 x86_64_linux:   "ef6bd356e28113b32d457342b53d745ff8fa88afcdd11dc1a9ef524cd69a4b81"
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
