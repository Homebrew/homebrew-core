class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.233.tar.gz"
  sha256 "b095def299ed4fc63cf177412553a5825a9e6ce94aa18074a5bd8a4168d02660"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "1d844518c1136fb19145e57bf49d109c60be66b48d4670f429f819abbf17b4a1"
    sha256 arm64_big_sur:  "148990bfcd8f33c71c9ce4616efe161082f5d8d9530d53a82d15f062115d8f60"
    sha256 monterey:       "1ee0b7a292c1fd9cb4d6c25d1c3a615c1f1d0b97007fbbdb4c386a9899603c0a"
    sha256 big_sur:        "8397fedf90e69337152143a433a85d0c566899f0fa5d85fc4ba11d481ec89f76"
    sha256 catalina:       "9ba56062bce179079fc50b31fb305daf020d37fbc981bbf307b97e7b38f24a16"
    sha256 x86_64_linux:   "ca376b9e07ed65dc283c8c86fe6755ad50998e2503b33584283f888f7fddf339"
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
