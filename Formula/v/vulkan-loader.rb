class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.321.0.tar.gz"
  sha256 "9e0315bd13d8def7d130524d0b69d0bef3e967374327ac69dd9c54cd2b716e8f"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "829b502094673c1d93cd47d0d6f15f15c0713e2553c0403dbb43ffbbedd06f4b"
    sha256               arm64_sequoia: "17a75d4bd3473b078a7adca737eb975374cf3f5d13a625a4d2a9bf7534e59afd"
    sha256               arm64_sonoma:  "838aa87d6aa49ad722d03773959f4c882a1a1711dce9f96c25658f52ecc55574"
    sha256 cellar: :any, tahoe:         "3a5fdc3914bdbf62ea713adaa914bfc1949b8d5634418dc4f7462cb67d0af090"
    sha256 cellar: :any, sequoia:       "e0987e426c2ff59ff188e6a0e82f9381be3d97f8c29fd167b923308d9a36fe2d"
    sha256 cellar: :any, sonoma:        "eae9057f906f658f584dfb9c4ba030b99468140bd89a7440d65c8eeb251b022e"
    sha256               arm64_linux:   "5c7d18b7a3cdea079c90c1f57e30d8bfa11336bd091c1f441764853c762819c1"
    sha256               x86_64_linux:  "f8afa9af215195b1c5e40729857af411149c328834882c0bfb4ab177e31added"
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
