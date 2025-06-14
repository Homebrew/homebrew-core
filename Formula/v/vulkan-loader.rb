class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.318.tar.gz"
  sha256 "b0e9488ab13d1fa946d50d7905fa71ea0536151db846ae4d3b485f869639efcb"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "248307c9934f1e1af7dea6b73dcfedc9da85e796017db755babb6b210cf1421c"
    sha256 arm64_sonoma:  "d1eb60c647024a80f7a0724f964d8401a2e0b0eacd925114e9195821e3ba1db4"
    sha256 arm64_ventura: "6e6532cf0b95c380dbe80ba3876abb65cf803c5299776f5dbb7c0a788037385d"
    sha256 sequoia:       "7f9d54a76a3a826955b70de5a0606f279235a9ea6dcb62ed249e649badf114fd"
    sha256 sonoma:        "258a016d53c6a689596a791f3fb36da24e3d447c93d6648379550e37db0dc6e3"
    sha256 ventura:       "66cf12dfba544c7ed897ef64e83948216378040b990aa3b5434df656d8537edc"
    sha256 arm64_linux:   "b6bc737cb8dd2b6459296b2ed678ef85f2bbf7a5078f25864be7a1a8a3ac5e5f"
    sha256 x86_64_linux:  "538a7cf933b6272bea94c733dd61e143fbfc299db917518bbc8ef6f64f77280c"
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
