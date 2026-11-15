class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.4.8/SDL3_image-3.4.8.tar.gz"
  sha256 "e8223b424bc7541cf84ffff5cf7e4f24ec3711c60462cb1bd6dc1d7bd7f25477"
  license "Zlib"
  revision 1
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bc50ca43127f408fff615450c972b9a19ebed30be203fb9ee410a7da58652766"
    sha256 cellar: :any, arm64_tahoe:       "26a4609bc61be9036967190527065779bf7de375d58f8db6f8da22b7d8b052ef"
    sha256 cellar: :any, arm64_sequoia:     "2024ba1cdc678d2d3e3356ffaa22eecafd06c295f867043450a1b8534d510d2d"
    sha256 cellar: :any, arm64_linux:       "29246410eef050e31731ffa188c54a3ba93590b0f9721ff3a43528c00ef47480"
    sha256 cellar: :any, x86_64_linux:      "6d04d9bfcfb4228a79b68da370b865867055452cae2cdcaf2cf6021525c72342"
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
