class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.4.4/SDL3_image-3.4.4.tar.gz"
  sha256 "29751304a13d25ac513f24305fa25b06a6edd9607718c90129b8350d35fc5573"
  license "Zlib"
  revision 1
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b32d53354e38f094fc1fdd92a9f6aea1cce9de58bd984bb1f11af3fe5cf75f6e"
    sha256 cellar: :any, arm64_sequoia: "cf1473822e8723702ab7467342a2041a4ee1972a428405860e4c376b4a14adc6"
    sha256 cellar: :any, arm64_sonoma:  "25891eef22524eb1905e3ef05056b02659bafa062cc25213753a6bbd6a6afffb"
    sha256 cellar: :any, sonoma:        "37636b26f17c37c603aad09462e1ba6d50111621f4e549363e69a4bc2b554ec7"
    sha256 cellar: :any, arm64_linux:   "ee1c0fb432242364dabfc925800e3c8ecf318a32739041125eec3bc8440a90bb"
    sha256 cellar: :any, x86_64_linux:  "d8954215ae9481088ee4736d7eead475b28479669d46f027d80c53ce2d9e5496"
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
    system ENV.cc, "test.c", "-I#{formula_opt_include("sdl3")}", "-L#{lib}", "-lSDL3_image", "-o", "test"
    system "./test"
  end
end
