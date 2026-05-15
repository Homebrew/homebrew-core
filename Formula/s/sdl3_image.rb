class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.4.4/SDL3_image-3.4.4.tar.gz"
  sha256 "29751304a13d25ac513f24305fa25b06a6edd9607718c90129b8350d35fc5573"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c76110cfbc7506eb501369d6334b463a36936008b6863df7cb835c45517ca76"
    sha256 cellar: :any,                 arm64_sequoia: "5d44ce88bca1f3f21de950fcba15fd3bb8bbc38f32ac44838e5c1f27561a14ec"
    sha256 cellar: :any,                 arm64_sonoma:  "6a9d78b8b78e56f0ceb2606b3db67803ef2a66013a93e7c333780d49490fed1d"
    sha256 cellar: :any,                 sonoma:        "74e04b9a96a5072a753b6c37b6d1531bffa0237c1865419d93c0650375133e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ca98bffc99d3088671ea84bc5ba2c53c8ef1f9baa907ac10dfeb33b4abc683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95e28fb18a16b1b66d515bf635919a8b7bf44dd1d483d938c031925ea95f511a"
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
