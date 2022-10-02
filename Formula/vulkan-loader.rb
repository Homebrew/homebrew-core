class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.230.tar.gz"
  sha256 "068d945faad57bc40dcf13ec5a918a17a2af2f80d090e382a33eb69ba753263d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "2495c7b375bbbe98dda27d80b022967fddae77e2fb559155299bad3a08d67c9f"
    sha256 arm64_big_sur:  "ffdf53bb38059fd4058320daa51a19217cb7c81277f2b2cde363ed1fb1851579"
    sha256 monterey:       "e20afcfb83b14f4033e8a83277943aadf749c7a794a449907211bca034b83bd3"
    sha256 big_sur:        "b4a224629f66366c12543a73c36d5514276b79cf63c4c8d05a78efac997f0c69"
    sha256 catalina:       "f75726c21daa43d0df63a5db628611e6092500c4bbbc0c1926ec4d3f727dabaf"
    sha256 x86_64_linux:   "a5bfe6db8dd123e932f226bace356899bc8cf747fe689848ce53f82d464cb796"
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
