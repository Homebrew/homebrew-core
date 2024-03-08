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
    sha256 arm64_sonoma:   "b9c2e533da1af3f2a0abdf21f1d9bce71175a34037b3be4084b26c713561d1d8"
    sha256 arm64_ventura:  "412446719a5b513a37b60ed558621d893c112ace1ac23e8ddcd2d31738a390fd"
    sha256 arm64_monterey: "ff6717606cf3ce179cfa1a425687b700aa2dd4de06379e07fb257a300993fbbc"
    sha256 sonoma:         "1e065a8a64dc3771d3efebb1ddccc0bb901c7d237f14b21c715fa13013ec491e"
    sha256 ventura:        "e775fb755f5f8e5889d5498e2309bfe039589c97ece135206f5f503da6fd596e"
    sha256 monterey:       "b887f799b65342fb1a1e85a6732d66bbfe73a43e137d09d7d8dd14b2093dec32"
    sha256 x86_64_linux:   "dae8b2c78b60c5fe0c55a56c0add19e2bac7f4b7e4e784dd368e40c8869aa8a3"
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
