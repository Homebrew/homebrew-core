class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.10/SDL2_image-2.8.10.tar.gz"
  sha256 "ebc059d01c007a62f4b04f10cf858527c875062532296943174df9a80264fd65"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4af4f5678df6e698c06eec00764c851ad6073a0c84374acbd4789ed3118847d4"
    sha256 cellar: :any,                 arm64_sequoia: "39ea4cab3c24d6464c4680f5364b3fe4cc2bd05412d2ca7ed301ce71d36f037b"
    sha256 cellar: :any,                 arm64_sonoma:  "789d926342b5030419c8d390fb41a1b10e24824459ddb694891baf219cc373e5"
    sha256 cellar: :any,                 sonoma:        "10edafacc760e03c4e345d55d3ecbdb62484e86a064fcf5a68cd3f977a5bb9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f7493edf1d8424f9230769cce95b8d1cbeb93b5a34707572fe39ee332b6e460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56bf1bd84d2bffa1db0e6b1fff8de36e69a22e5a1dd962a0adf4b0d72f943b6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    # upstream bug report, https://github.com/libsdl-org/SDL_image/issues/490
    system "./autogen.sh"
    system "./configure", "--disable-imageio",
                          "--disable-avif-shared",
                          "--disable-jpg-shared",
                          "--disable-jxl-shared",
                          "--disable-png-shared",
                          "--disable-stb-image",
                          "--disable-tif-shared",
                          "--disable-webp-shared",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL2/SDL_image.h>

      int main()
      {
          int INIT_FLAGS = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF | IMG_INIT_WEBP | IMG_INIT_JXL | IMG_INIT_AVIF;
          int result = IMG_Init(INIT_FLAGS);
          IMG_Quit();
          return result == INIT_FLAGS ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
