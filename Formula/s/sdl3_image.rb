class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-3.4.6/SDL3_image-3.4.6.tar.gz"
  sha256 "d2e4637ae700f72e5196b8fbd749850ed2e5e1e09c5a5be8d06ff55aaccf3b01"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "23b752048fa22c904625e6c6108cafea7c2f1112ddfba515b440303592433747"
    sha256 cellar: :any, arm64_tahoe:       "6efcc3fde7c11ea176554ffd48dd3f6a98faf5639a4e193cdc77aef6752f7422"
    sha256 cellar: :any, arm64_sequoia:     "51b8ad27d2282716a7b7a3ecc20deb22f69aa2405d141caa8f17d3d5b21176d0"
    sha256 cellar: :any, arm64_sonoma:      "aa80e4b7d4f8eff14475ce2546c82453580ae42569686e8597b2574c1e42d10a"
    sha256 cellar: :any, arm64_linux:       "c701dcb61029cf0c5f01ddc07e4ef7387b22a81514da16c0305e20213e7befa1"
    sha256 cellar: :any, x86_64_linux:      "039721d90e8dd34aa2540f505a96501ec5edfc2b910f3b891f93ca08f324ea57"
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
