class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.293.tar.gz"
  sha256 "907acffe7df64d111dfed4bed1cc77a0dca9648cd6c2eeb49c2370c94a57d5d0"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "71d5f1aaa7c51554aecd6132ff91f94ce480cb2aeb7c502ef32ffc4ace3d342e"
    sha256 arm64_ventura:  "ffcaab88556d24beae57abd081b70f879da6623fb30b26b9a0cda9b93b0fc59c"
    sha256 arm64_monterey: "1279db44467c40e0f74ea42d10f3cfd31e90f8e5112e60d0915cce0a28a78a47"
    sha256 sonoma:         "f62c57250ddb048893c60adf763be5379c1d01b0069bfac608c9a44adac3ce0c"
    sha256 ventura:        "743395b3ad344e179c0c6f65767883477f61608c148ed8b060a8a05e85151dc9"
    sha256 monterey:       "aa7697c7c54fa48449d1a8a53907cfc52dcc63d30cf019b793d3842e64c4be5f"
    sha256 x86_64_linux:   "ceddbc6909bc874bfa16b2db77b966cf3ee59819f00af2e2cf3eeaade10b6c94"
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
