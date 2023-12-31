class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.1/SDL2_image-2.8.1.tar.gz"
  sha256 "e4cab9a58c347a490c46723c17553b4e12233cd821d3b993a8475a50497f5a3e"
  license "Zlib"
  revision 1

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe0ffbcd382f059efedf51c666c458300d2b17104dd8bd9a0987d5d25bcd4154"
    sha256 cellar: :any,                 arm64_ventura:  "a9a00c6f16ef925bb1f0bf4df6692263a2504ed927fad897c1edeb88224efd0d"
    sha256 cellar: :any,                 arm64_monterey: "42fd043f4dfcd7f32a3ce80a70dda7c31b114d7c8b6afe6a63061293b8adab01"
    sha256 cellar: :any,                 sonoma:         "f7c9b181733ca467b3333ddca9af670addaaad2c770d0d00a7520073b08b93d0"
    sha256 cellar: :any,                 ventura:        "c17fd1c9fbd15bb223dcdee1d2e2f32466d61c7cef4b42de162db16f5ac32534"
    sha256 cellar: :any,                 monterey:       "97ed56bc16fc0eb9d5110815dc23d6a78c89c4e71f859d733f10b367767c67a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8963ecaedfa220550cd9a7e4ccbca99d3a248f9c2d39299bb06af9824e2c7739"
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
