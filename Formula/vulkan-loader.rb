class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.234.tar.gz"
  sha256 "aa4a24b162e8b719c0137b090dadd16970e71e2e3a33e5426607a42142ca4a19"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "f9497d45e1c530fb5314d610f0ca681858e01c28b9386ad11c4c7d7aeb31d7de"
    sha256 arm64_monterey: "857cb05c259c2fed3f2409aad738285b3b69ab283213f44852e660be53fa402e"
    sha256 arm64_big_sur:  "6a81dbed64356a3eedf7856ea5772c0efefdefe9c08cc9d3ee9141ad0bb29197"
    sha256 ventura:        "441bd0e5114d149d977db82e054228572690d6bc26ff137df1e7fa018a66bcc2"
    sha256 monterey:       "17241e6bcc3bd783e430a8dae5bfe6b0fecac3c34ba38addb355aab482e1c797"
    sha256 big_sur:        "7504ad2012c9286aac5a5ba8488ed978cd7d616485763a280b544dad854948e1"
    sha256 catalina:       "96e90853b3236304fa2681d2d1bdc16ff698f92f73acc38819d36c5393d674d5"
    sha256 x86_64_linux:   "d6b691d0b702b00f6836cf7fa5b20d9c483dd42f0851ffa406df6ef55f6c7d85"
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
