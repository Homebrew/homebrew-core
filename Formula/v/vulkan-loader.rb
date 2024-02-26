class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.278.tar.gz"
  sha256 "a22ea209ef1a0fe2ae77dbb355d700d20971f1bc8937efe52d885bd8bcbc447b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "48c794715ac932efc7180d7ede5b0e9718d0aeb91f12055776a42b4a090b86a0"
    sha256 arm64_ventura:  "45b13354cd95c21baa2ae5588fe10d659cae2fc581799a85de7fe89b0837c16c"
    sha256 arm64_monterey: "877c61243f2c39718b0c8a30b0aebbbd18a606773da2d1534333ff2c9abf3db3"
    sha256 sonoma:         "58ad57fc969cd5dc1c9881dc876053bcb40e5d86efc74405b9503b27f2444f7f"
    sha256 ventura:        "a5ad7c90f2a7c952d3a8a616577e4e25f8f01b879b93f65c36adfe87c5e8e3f6"
    sha256 monterey:       "8268b8816be7f75109754ec9c067684561bb782b4d286aa7b0d26261b8c75354"
    sha256 x86_64_linux:   "6e1eae1a6b60311902c39bab3a3aca127b0db73f0b1d3bb001068994e2026c40"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
