class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.2.0/SDL3_image-3.2.0.tar.gz"
  sha256 "1690baea71b2b4ded9895126cddbc03a1000b027d099a4fb4669c4d23d73b19f"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b4a40bd5b49da068f9f7b1aa6416ea1608435a6b962880d1f4005b3c12c63c3"
    sha256 cellar: :any,                 arm64_sonoma:  "ce64145b5f82c159ee9791c5bdb8a2d44090b3de8851f8454458f8b2124c43cb"
    sha256 cellar: :any,                 arm64_ventura: "b2576e6ef14d01ef979668451f3894258e3f4ec10620f974cf276f06a1a6a49c"
    sha256 cellar: :any,                 sonoma:        "0a5582939101f4c5fddc3cc4a17f288778a55b18164412b059c9fc503bcaf752"
    sha256 cellar: :any,                 ventura:       "5db9220c012cc50214d03950d86eab0aca7d529387e3119706fc66216def2ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4806be12a2ccd946d99cdfdf6ed5022ee19a35091da9222845cae2e1bceb23"
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
