class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.4.0/SDL3_image-3.4.0.tar.gz"
  sha256 "2ceb75eab4235c2c7e93dafc3ef3268ad368ca5de40892bf8cffdd510f29d9d8"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "747ea7edb3b3be0c4b68e2d7a5596ff506aecc5c747f23d707c8096bf76d1823"
    sha256 cellar: :any,                 arm64_sequoia: "8fb4937c21da8ae59022692ecb8a98cb9ea78edcd07c24d58c9aefb479f4487c"
    sha256 cellar: :any,                 arm64_sonoma:  "f0ca74255314552aeb66991fedd4653879e9a5c274a95e95ff3221865683df49"
    sha256 cellar: :any,                 sonoma:        "ade19831bd658d85858ba693fa23863ed07d6a889a2cb7202610137671da8e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a426057a80eed6a63bf4c1ade0126fd2c4cf5b3c40a50a89163fc14dd7aef80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ea7ba27dcefae4c2f4d6d20e272faaa299d6c2407965d148d2ddc81c18277f"
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
