class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.341.0.tar.gz"
  sha256 "fe982697c780a950641bfcf94707135c26c501352242d285fa95d087d691292e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "3295a53bff2bc054547a46bb7e62f44220a8401faca4dc74eb99ed247a2b2f45"
    sha256               arm64_sequoia: "a5f42668283bfc61f5236ca10f015dcbc72ecc4a536a6ddbb698e4aa6c6759f7"
    sha256               arm64_sonoma:  "8ebe9d966b66da422f245451ea6965e56b133bdff040385f6a485dca08a8b724"
    sha256 cellar: :any, tahoe:         "9dff81362f512a5b18fe28ff26b1593c22f1928c4a197648aef5b7b950747777"
    sha256 cellar: :any, sequoia:       "7eef7a09a206a9174c94b8a1e5a619dad47ddf7d42eebccd56f6820e210411f9"
    sha256 cellar: :any, sonoma:        "748166fe572e7c2605c52fa53f5e5f4e097a2c84eb016848d8b371386eee6fc9"
    sha256               arm64_linux:   "384d36d5cda7ab774e0592dd2147aaf3928f762c063a0c5725f2b3189c9d3e7b"
    sha256               x86_64_linux:  "19929669867dd2f30bd4943506aa08ae295434a68712c649d299daf7422e2247"
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
