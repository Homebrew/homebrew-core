class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.350.1.tar.gz"
  sha256 "602984a71000981e25e4feb419e6cdd70b18ffe2b8004f60f591706027bca468"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "29759c4cff4f88360ee973d63bd99ca70131b03cac1256e0642ebb9756c8950f"
    sha256               arm64_sequoia: "6b7eb107811b05b92b9b5e1c14647722a9c47e016d3921b5a410f00895be1b54"
    sha256               arm64_sonoma:  "261bce178335121859d60a346adb959e40eae19245de6f85a06c7dd45e196579"
    sha256 cellar: :any, tahoe:         "03185dd14f4a4501875b38cac7b69f11a2dd6921df4deaf7436aed74d62186e0"
    sha256 cellar: :any, sequoia:       "a7e2766c852d38bce1bba888514e8b521de7f728be95d5221c485f9b1da253bd"
    sha256 cellar: :any, sonoma:        "58cc4c6ca21c8cb61ff31999072aba60324a679ce1e0b670d524209053c0f4a2"
    sha256               arm64_linux:   "58a2d3afe0e3047ab182f798478f06b635a189f05e160f9797da56a4ff60eaad"
    sha256               x86_64_linux:  "c5d2a2efe027c9a1f5bca341c724fce453052831fd4361da0cd52cc8109a7f66"
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
    system ENV.cc, "-o", "test", "test.c", "-I#{formula_opt_include("vulkan-headers")}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end
