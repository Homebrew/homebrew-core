class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.297.tar.gz"
  sha256 "7d140e7ece2835a0374eda727925ffcd8fc5c9a183dc00b87d635e230e6faca4"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d56517188d86b9c64229d9d03e86346178964994c89c71af296b73dac4ea360d"
    sha256 arm64_sonoma:  "90c2da02e6667ccc0d90a1a74a7428e063688124d3c2c4c018ecc17beb494114"
    sha256 arm64_ventura: "6020d8e44cff54e536a5714460cb0fd692e5703c71a2cb494907635226ddf684"
    sha256 sonoma:        "e72c9a513a68f1ad01aaa12c0ffbcf25e86ee755362294e0fcfeea6f7a459b38"
    sha256 ventura:       "af83c653a3be50a7101820d322516c3a55f339d7b4afcdbcca7f49d5190d99db"
    sha256 x86_64_linux:  "a6a22cfc013aa7191f57fe608ac6c54beeef3ac9bd55d7e5a838a420b2fc2a7f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
