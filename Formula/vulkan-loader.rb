class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.243.tar.gz"
  sha256 "dafcddb1e193a7da3b18d51748c634af9e3d1bfade524773fbf3f297c955396b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "da9918f23f395b81d942e578d516b7f691be5f2bb66cb044e53f3beccea74007"
    sha256 arm64_monterey: "5dbe4386021143711db5e7874fbc6f4e17a259e72449681ac9a871b2361df0d8"
    sha256 arm64_big_sur:  "dc4fae8dc6a9b58216fbaaf4054f8bcf61fc1b86c26163eb47d76a227711c5bc"
    sha256 ventura:        "ec619d701772d769de3410335855c26ec1f06bf1a363cda7142634503d742375"
    sha256 monterey:       "202b58286fde44e03da3d8e3d3aaf1891c00aaa7b0313927ebd058647eba2b4f"
    sha256 big_sur:        "7a761fdddcfca424cdd32107079ec7e4142e96b310bcc36134430ac94feb9b9d"
    sha256 x86_64_linux:   "ebd899e1afc31b6560f45ef0159c7e0116ae2b1d8aaec3dcd15afe5f89567276"
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
