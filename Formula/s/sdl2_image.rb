class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.4/SDL2_image-2.8.4.tar.gz"
  sha256 "5a89a01420a192b89dbcc5f5267448181d5dcc81d2f5a1688cb1eac6f557da67"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed3632b4a27e9c7e2ae007a983730abdb50deae3a7542010ab0e45c8e2ec124c"
    sha256 cellar: :any,                 arm64_sonoma:  "2be0d91084416dbbd6503ebfd48e205196961aee5db2dd79b1878bf521258b4a"
    sha256 cellar: :any,                 arm64_ventura: "8ef0340816bcb14e762cdaf359049c4b016f05731456b3c65beddcf2232ac338"
    sha256 cellar: :any,                 sonoma:        "dc23b3a464a46993633a8d83162e9d8b8602d5d081dd2727ce95824c58bdfc46"
    sha256 cellar: :any,                 ventura:       "d206cd994af7994f81c64304cfc353be269253a93b812337a38ab347bc00f54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8cc1e020beccf7d9f6c2e2bfd52c93e0f0e20c59047ba6b569b1d374cfba551"
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
