class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "91f88fc43abb36821a568c7fbb3f815e9baf946d5fe187928df279708d45e509"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "a3ed8ff9247a4e058afb5d17c9c87856d95b5681409f1b5d230b671691769101"
    sha256               arm64_sequoia: "20f5cc0a364d8875c3d5f256f88d7795678d6afad1cfa7447ddceb928d5e0c9f"
    sha256               arm64_sonoma:  "ea5d2e9c708c61482e5b8f6d8acfd46626db1191f945daff914e53af358b2a41"
    sha256 cellar: :any, tahoe:         "5761fee6fae907918097c8b4b86c22cd17cec7e9ff295223e2e584b5bb314991"
    sha256 cellar: :any, sequoia:       "5e443d4b19f0b3be2e2eef152249f5ea0f8d8d1d2704b8e226d7ef898527ae6e"
    sha256 cellar: :any, sonoma:        "2d266cb426bdf54c35c26ef16d1afe9d5aa7df8921476702f1f29a7d33cac611"
    sha256               arm64_linux:   "cac29a07107d501055ce5584e0786e8d26fdcc59f234454c1f4af82e25d6df54"
    sha256               x86_64_linux:  "082a2139e5d1f6070f7d20eb920ba0ea9141aa4a5d1523fb5888e9fceb2b4094"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end
