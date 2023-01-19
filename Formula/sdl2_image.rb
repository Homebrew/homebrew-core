class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.2/SDL2_image-2.6.2.tar.gz"
  sha256 "48355fb4d8d00bac639cd1c4f4a7661c4afef2c212af60b340e06b7059814777"
  license "Zlib"
  revision 2

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c257462100f9bb6cded5309ae50de83b07507904866678d4ad0182f85531fb8a"
    sha256 cellar: :any,                 arm64_monterey: "638f55e34b8179e1915bc081d7a7e3d6cc391798db8254755b2d0c77240da39a"
    sha256 cellar: :any,                 arm64_big_sur:  "eb448629373515281204ef6ffc2b1e9cc1eed5cbb3048c8f2f3022d9f8a6f6f6"
    sha256 cellar: :any,                 ventura:        "0686d114e5d196fa0d84daeeb33ff13081ed400ca8bc14bfe691bcc7baaf637b"
    sha256 cellar: :any,                 monterey:       "3f60cdfb8bcdef6c2a97d3ad6980720d6520070ab2d0901a8b71fc060664ab3e"
    sha256 cellar: :any,                 big_sur:        "816683f6ab2f30791075eba45e7022850532e945f3a18b421fb1a0a257307211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b337286ce29401e6100bf00f0d734231a2e794d30095d81a0b03f55eda293187"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args,
                          "--disable-imageio",
                          "--disable-avif-shared",
                          "--disable-jpg-shared",
                          "--disable-jxl-shared",
                          "--disable-png-shared",
                          "--disable-stb-image",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_image.h>

      int main()
      {
          int INIT_FLAGS = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF | IMG_INIT_WEBP | IMG_INIT_JXL | IMG_INIT_AVIF;
          int result = IMG_Init(INIT_FLAGS);
          IMG_Quit();
          return result == INIT_FLAGS ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
