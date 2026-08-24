class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "54f2537df22313768da0317dda2abdaaab7711b4081c48c869a79db343d0ae70"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "fcca79db1d905b8d119ac29f172e3fa4c2a5a9928eee5865e11131492d7f1f67"
    sha256               arm64_sequoia: "de7b6b62a8ad6853bad4d8ea7d75f08f41c21ccfc20d9cd62530a56964e8c9b0"
    sha256               arm64_sonoma:  "92170415f9888f72039bea6842415dbd876ff9b91087100b6948c3ccac103632"
    sha256 cellar: :any, tahoe:         "f7f978d658f318dd83dd51ddd44c144f977c7f7e51749b66031d225a8b9c9ec6"
    sha256 cellar: :any, sequoia:       "25dd0dabe2f62b4790ec5b0f200a562bd9abef2d5a88401a7211eadf52ddee77"
    sha256 cellar: :any, sonoma:        "10ae3553cc035a21770452181d128ff769dd3d62a6758d3e8b7ce0175ac7710e"
    sha256               arm64_linux:   "3086b072972040208ba198d6c1fa0a9532020dc670311af1324df912b903a8c2"
    sha256               x86_64_linux:  "28808a994dd5f3530c4ef3591350bdb6495609c7caae974e5f1e87b9db4ef4a4"
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
