class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.3/SDL2_image-2.6.3.tar.gz"
  sha256 "931c9be5bf1d7c8fae9b7dc157828b7eee874e23c7f24b44ba7eff6b4836312c"
  license "Zlib"
  revision 2

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "bb43982d9f926fb5be7983d2aa4c74c1b045c0ac81656e8326b8377d011bd6e7"
    sha256 cellar: :any,                 arm64_monterey: "7865d5fc5d7f76abf3798b9b44bd03b92cb4ad0805eead866042effa37c7ee63"
    sha256 cellar: :any,                 arm64_big_sur:  "4f8f838052625cfb3356e465785aaaf0f8d61e6394dcaedaf1bc44460ce462a5"
    sha256 cellar: :any,                 ventura:        "d2207f59ca7a2dd0ecd2584b47220de9344b3d1b6d3069a15d67b24d6f0d8203"
    sha256 cellar: :any,                 monterey:       "22da2defb584868e75af04623219ca07adf78d495c166c10deb56fdc485abf63"
    sha256 cellar: :any,                 big_sur:        "eea32beea59b8a9ee9b3f9a064a82607e08a1c75ecde8f1aa8ea12ef647786b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d26e8915542c685991d8da6b120792a7948b374491dcbe8bdedd75ceac5806"
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
