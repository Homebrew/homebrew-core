class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.263.tar.gz"
  sha256 "9c84474c9668946ad0ff291df3147e109ede5bd417e512cdfe6c71e2a231dc08"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ac9880862e84d1305e68220203c91a94a843b02ec388e1cf0021db17f2a4489f"
    sha256 arm64_ventura:  "aa4de5de39fae458f9456a1cd77665305a88a4d0eaf3d2c6f24d84ee379ae438"
    sha256 arm64_monterey: "2078f25536074f4161a23b5294b00e27d536e219a35a4b83176bb0c8448c0038"
    sha256 arm64_big_sur:  "859ed627cad7e34998269762381eebfd8be45c599607ab86149f16aff598baf5"
    sha256 sonoma:         "a3183fb36ab31dc8a45f457634e97796806fa9be772ab52048e38d83d434914f"
    sha256 ventura:        "745c5b5a127b3b49da0950221062f1714d9e8746d326eca4c8695a9d21162f8e"
    sha256 monterey:       "162cd814aefd12e232161bde957fb9f1bbabf3eb499715a12dec34643221a883"
    sha256 big_sur:        "c29e15d5014bfbe1e288673923b4e1a54182e5aadf7a59925f39a705ccdeb593"
    sha256 x86_64_linux:   "767d18fab83036a1c5bbfb93746e2f87e7137e4e1b792ff003fc48e3fffd865e"
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
