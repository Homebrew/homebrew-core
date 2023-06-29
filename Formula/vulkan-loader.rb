class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.255.tar.gz"
  sha256 "dbce362b3279ccd3518f0d1a4c64641019390f6519a0af0f371518cb10802bfd"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "b6d930aacad8d9a6afd8247147f75350dce2c80d5bcb48a5536b0db71c08bbe9"
    sha256 arm64_monterey: "b845f1d1e7a7109b2a536f0612d17e812e5ebfdbe530be467e5cd1ff962c85e5"
    sha256 arm64_big_sur:  "71bd02b9c34c152dffd3616c6fbe1e1e6847155ea6061ad5506b54f384446d85"
    sha256 ventura:        "6a9a84c04e444b15eb022bfe1bd9b026c6062ada8e44130352713e6b6d8fe758"
    sha256 monterey:       "adce23c20f48db235504b5c2fa7e4210ef26464562bf2d974193aef6d254b1fb"
    sha256 big_sur:        "d0a6b1d9560d03195c57ab5471b578a52316a03c88daaff1fdfd8713c5a26b13"
    sha256 x86_64_linux:   "87f788b0ca60e0bfcb5732b35dab1dd758a82e1b5a7ae780430a63ac77efd90c"
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
