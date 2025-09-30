class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.2.4/SDL3_image-3.2.4.tar.gz"
  sha256 "a725bd6d04261fdda0dd8d950659e1dc15a8065d025275ef460d32ae7dcfc182"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e05b526d9b2985d155391c14c123e2a744357539340c7dcf930c73790637e255"
    sha256 cellar: :any,                 arm64_sequoia: "784b36fb3b932e3001d88f6bef9922b70ed8f39a24262dbce396224d15bab222"
    sha256 cellar: :any,                 arm64_sonoma:  "40e186a16a24afb506bce144f202e557360eac08062f03af5f5b1ebcb68ddac0"
    sha256 cellar: :any,                 arm64_ventura: "e573dabef0b0281c03906bdca0dad06fbfeed385562e9b77b0d89e1dc0152f66"
    sha256 cellar: :any,                 sonoma:        "36d6f234b606db2282c7ed6cb1f747a48f20f12478895f802054a9ff26f5fc5d"
    sha256 cellar: :any,                 ventura:       "4dbafe776dd24e700747ff4d1cae8211d4ad35d7ca0eca0438e73b523d2d1030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87a8097636da45ac5c760b9a733f6b02a5e1ad10cd0f6f2130c9f0e1be5ce9af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36d6a7393c7b4da3cc884be73b8652e8d0bc93e337f246203c0daec81c293d1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl3"
  depends_on "webp"

  uses_from_macos "perl" => :build

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DSDLIMAGE_BACKEND_IMAGEIO=OFF",
                    "-DSDLIMAGE_BACKEND_STB=OFF",
                    "-DSDLIMAGE_DEPS_SHARED=OFF",
                    "-DSDLIMAGE_INSTALL_MAN=ON",
                    "-DSDLIMAGE_JXL=ON",
                    "-DSDLIMAGE_STRICT=ON",
                    "-DSDLIMAGE_SAMPLES=OFF",
                    "-DSDLIMAGE_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL3_image/SDL_image.h>
      #include <stdlib.h>

      int main() {
        return IMG_Version() == SDL_IMAGE_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl3"].opt_include}", "-L#{lib}", "-lSDL3_image", "-o", "test"
    system "./test"
  end
end
