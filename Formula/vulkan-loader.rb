class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.248.tar.gz"
  sha256 "5a5e51c568ea4344fa93c562eca730359a9562c4656dad53d2cc3f4807ec2307"
  license "Apache-2.0"
  revision 1
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "7bb6b60a902d82cd34d1f0413a47e0b27801aff464cef84e1e45dd86036247e5"
    sha256 arm64_monterey: "a55038be45869f5ed7ec66e178ca1ad998aae6f3a225932c83cb938d3dfbd914"
    sha256 arm64_big_sur:  "a36057b2e157b400b18398c19d98b2397cd79821f590fec84c489a153922e145"
    sha256 ventura:        "2ce8145f14c07a9f4b4dfc0398d02e505e2af30ac3be5a15046b902d9ad7ae5b"
    sha256 monterey:       "2b0bffd1c6e809644837ec7c0832cd4caf6d6bf767ff48869333b591e8cb8c0d"
    sha256 big_sur:        "5c3fd3f2e28ee2c9ef934212cf4f74a3648ad4dc957dd79ab6b4025f424984e4"
    sha256 x86_64_linux:   "426d6e235f7a94bab784b8a57c2791cc3c4840be06a8155d1f63527223e5d866"
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
