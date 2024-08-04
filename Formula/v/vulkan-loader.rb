class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.292.tar.gz"
  sha256 "335d710d0479f89091674cdf7c0cc955aab41022c176ff8dceb1b630381cd72c"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "686ad04e1c064a0bf679d80525fd5d66c48b72e53c3c742f5a20d7be16c93a61"
    sha256 arm64_ventura:  "8cab494626c2ab150a452742d561e2f595dff03bd04bf7b54e5cacfed241f330"
    sha256 arm64_monterey: "c98e089f14f22ac75767edd3b860cb102692d226a2ebe7670b239f0390a0e119"
    sha256 sonoma:         "ff7a76a3717110ca9616d06db8a03918011eb2a044a1c30fbe47dfa90313260f"
    sha256 ventura:        "aa4825545c7cb1ca45e9a2ef6ea5e750ac576f752155aee913c628a271f211ed"
    sha256 monterey:       "c22795d80453ad082320fd0c26434a0add3135b6584653d3225576d6a25aa8ec"
    sha256 x86_64_linux:   "f97f4fcc5168156858fc0e7bf40a4e5983870442b07e7b5cad2e53618b6f5b09"
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
