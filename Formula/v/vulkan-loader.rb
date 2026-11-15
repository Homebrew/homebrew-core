class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
  sha256 "941eff558fc74f248745fb7df367640cf89a8457f216dae498a74ae14b6ba6f7"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "65ddf6c37607565edcc225cb6b0e7ae3d46b3b0f55e961d35edfad322e72e4bf"
    sha256 arm64_tahoe:       "6d5ee00d4104774f3ae56e5e9441a59a6a6f5d800f937f4e926a8f9e01ed046f"
    sha256 arm64_sequoia:     "4b99cecb4fe7115a6faf770cfa9e8f14426c24baa6e4566e2473fe5beedad5af"
    sha256 arm64_linux:       "96859d946e8d84cd1d597b76adbf4072452425c8e3c09a9dec167158d94d6e2c"
    sha256 x86_64_linux:      "06612bd21d79e035219a8e8723995b33416a3515bdb5fe2e08cb07a62899459e"
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

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{formula_opt_prefix("vulkan-headers")}",
                    "-DCMAKE_INSTALL_INCLUDEDIR=#{formula_opt_include("vulkan-headers")}",
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
