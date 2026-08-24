class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.12/SDL2_image-2.8.12.tar.gz"
  sha256 "393f5efb50536ec13ca4f4affb69cc9966d3c3f969e6c5e701faddf9f9785381"
  license "Zlib"
  revision 1
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b62a3b5eee874ca79f59bf3b8444f114639b84abc377e6d9ee6559d38a5eff91"
    sha256 cellar: :any, arm64_sequoia: "58de60b25e63f6acfef778af04786cd581bf5dc31c87160f0fc77cf6624795fb"
    sha256 cellar: :any, arm64_sonoma:  "962472d826e05684e5325f887cde05082d87688851586deeb414ceb1377bc065"
    sha256 cellar: :any, sonoma:        "6123fe46d70f72623fbbc8c6f9817f91596034de03fce70cfb4af2f42261e04a"
    sha256 cellar: :any, arm64_linux:   "232052f2ea239606d2e4eccedd5cd682f7fcbf1034a306271421f6a7676957e8"
    sha256 cellar: :any, x86_64_linux:  "ccac7716bddf53e05caf908f1ea32aeea13623ce285f1e85477d73a64233ca45"
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
  depends_on "sdl2-compat"
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
    system ENV.cc, "test.c", "-I#{formula_opt_include("sdl2-compat")}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
