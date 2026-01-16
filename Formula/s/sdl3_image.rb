class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.2.6/SDL3_image-3.2.6.tar.gz"
  sha256 "2daee16e6f8f9ea1c59ea243c0b089e2a2c7a2c402efa67f291a6359e5bd50d2"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25fa2fff7bcc01bdec93f57335163bec94b72d377c8e7a4c0e827783f6745b82"
    sha256 cellar: :any,                 arm64_sequoia: "30d46fa48cee0ce8a4146efc76c45cbd62f632272a39d9508590e06938494a02"
    sha256 cellar: :any,                 arm64_sonoma:  "08556c09f8cd3271347480b5ece8d6d50588fa7cfa574e0478ab56b4bfb783bb"
    sha256 cellar: :any,                 sonoma:        "3e59be63a0a9088964a2ce67d60d0e5a379da63d2c47be637ec2be2764b8ec43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "582533d4f6544157a900fb016e7ab4ca160d7d73e52e452ed0976ec7c128b514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e50f4eb61801e82182e0035417a9bc4312775c433cf8203b7ec4a5c94224b59"
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
