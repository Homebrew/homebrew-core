class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.232.tar.gz"
  sha256 "3e30621aea870bfe12227018e73926d4bfacb46b0b207553eb2ebd966df1b202"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "5286f70f46ffcf2b5b37256fd700596c5cbeb9f669a43dc0a95ff76d0ac7ef68"
    sha256 arm64_big_sur:  "f6784a4618b78a43cad5a513f7dc3463474284237205dfab6adc7c256f894068"
    sha256 monterey:       "276f1a999783e8039bf4a4f29117672aa29cfea902a9b63e9a51fd851792d768"
    sha256 big_sur:        "755ccfe6c175f6caf8885cdcfc6aa956727db152f689ce357f51f51820640290"
    sha256 catalina:       "941d20aa60d0ebe16d97219226d5ea36ca8a09a15718637a158c636506c9c0c5"
    sha256 x86_64_linux:   "85d755963d0bcf0990ff11d6255995ee494b4363bd4e1d2f8eb7c89adf08909e"
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
