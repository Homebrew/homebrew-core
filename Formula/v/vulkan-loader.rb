class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.320.tar.gz"
  sha256 "8cec80f3b617a30a94a354121a47b090187d5fe70f668eb26eb71010a18a88a0"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d867ec9378b6600c5aaf858717733e609cd265df8cbe664cc155ee7fd270f07e"
    sha256 arm64_sonoma:  "1629d458cbe979a5e8e2b4af15c26a201dad1d1445a2f8eef2bde9ed9fae5387"
    sha256 arm64_ventura: "9b34cfdb71560b0773e799106291512c5ed10dd0d20c518ab7af9ed259e3b89f"
    sha256 sequoia:       "f15e6a7ebd4baf2dadb2c8c63d82b053ae07db34ba5039a964a989da24d88c5f"
    sha256 sonoma:        "0c2510886e574f322aad375a8cb0a45c363ffc6e3cf186ad0bfdcb3568524a17"
    sha256 ventura:       "1dda6914ec6daf65ea40b0b424c045d2146881490da2b7155b076d75b65deb2f"
    sha256 arm64_linux:   "a3f570ad944779926bb4052560b0c03fab4771e89fda9927c5a67a4935ec8252"
    sha256 x86_64_linux:  "064e1edc907fe2dc96f3d24fbe72b641699cf7b25f9e74d98927970d91d1a5c8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
