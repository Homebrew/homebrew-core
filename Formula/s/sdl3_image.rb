class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.4.2/SDL3_image-3.4.2.tar.gz"
  sha256 "82fdb88cf1a9cbdc1c77797aaa3292e6d22ce12586be718c8ea43530df1536b4"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9883391401d35d5471b07e31623879871329e8c08e81bfbdd8869ffc008c75d"
    sha256 cellar: :any,                 arm64_sequoia: "1f05cc7bb284351d96b63be2361d2aecdea095c99c321eda0d8efaa9249ea38b"
    sha256 cellar: :any,                 arm64_sonoma:  "a4e25e07df701311160537997c234eb773d8077e8870bd3e8b6287a807848d0e"
    sha256 cellar: :any,                 sonoma:        "0589ddd15e5c615aab40ac2001f25d4142777a2e20aba8a2970b4e21f3a06f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f158a53fa035fdc318f519739654b79668f3638754ee1b51501274579d2cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40ce6571044b5653f735f7c5615e2b8233b8499c9d7f7f09a884a1c136fff42"
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
