class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.4.8/SDL3_image-3.4.8.tar.gz"
  sha256 "e8223b424bc7541cf84ffff5cf7e4f24ec3711c60462cb1bd6dc1d7bd7f25477"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4d8f6a8e319e3bd56c14b18d0e1c0ef299a0ea123a50bda75c55e14410387519"
    sha256 cellar: :any, arm64_tahoe:       "e13a146d87b3bdb77792e8a83eae9d491bb7c907c3115a883ab95f1b7c5a8d6c"
    sha256 cellar: :any, arm64_sequoia:     "bf95fee939fc7b2a1424aaebb80978382cd15c2135441069e7776c9f6faa1ccc"
    sha256 cellar: :any, arm64_linux:       "005b0b443fcd4158610cd346d8d81d8676b38b6e312bff48f4e211ae5c97a88a"
    sha256 cellar: :any, x86_64_linux:      "ad512482a8e8ed4125621c2d0f2a701307273d83a3c7ba2f86f6e40c9dd110b9"
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

  deny_network_access!

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
    system ENV.cc, "test.c", "-I#{formula_opt_include("sdl3")}", "-L#{lib}", "-lSDL3_image", "-o", "test"
    system "./test"
  end
end
