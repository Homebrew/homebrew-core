class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.257.tar.gz"
  sha256 "9d6d1b19ab040a95f70f75db573080d567e41dd35a018ed9dfdffef3230003cc"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "2e31eee2eed4c1f0fc387330d01320597fe635104dee579be7a9332ece6132c5"
    sha256 arm64_monterey: "a66c5d9b095f3f8261099e16c6c7bbb71732384a0e8059a1991000114abe5dd7"
    sha256 arm64_big_sur:  "0071b075a3ca1886aa9b3f3ab9dae288230fac5eda05be6bdaf02099644579ae"
    sha256 ventura:        "bba7dcee4697498667ee52ba6e752f4dd13e5b87d8d92d64ecea27f099930652"
    sha256 monterey:       "61db0d777dbaddb2a433c8db8c9ad0800d95fa097bf4a0943f8dabb799c10508"
    sha256 big_sur:        "b0ce9ffdd098ad722941972ee411aad3412d538d46fcb40a625ae1485155c7c5"
    sha256 x86_64_linux:   "fba7799a44b73efb48a00787c6d16ae53a9a626237cb114bc03905b7d07954db"
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
