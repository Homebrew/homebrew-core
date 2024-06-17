class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.2/SDL2_image-2.8.2.tar.gz"
  sha256 "8f486bbfbcf8464dd58c9e5d93394ab0255ce68b51c5a966a918244820a76ddc"
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
    sha256 cellar: :any,                 arm64_sonoma:   "11c9581ed82a84f5c63626690d7c3c9c98fba13265e6491f31f985a782adc1cb"
    sha256 cellar: :any,                 arm64_ventura:  "ce011bc3fb0f71b07b634bf8b2a0833df323eaa758da3dd6fc0c7ee5b0c2f5fa"
    sha256 cellar: :any,                 arm64_monterey: "32a207af0f34a17677ff240d637a07214528c716c19cf8099ba155e25bebb9cc"
    sha256 cellar: :any,                 sonoma:         "308fdb3aed323827bfbf6bb7e669553af535268d933511ad721ae43e38b54860"
    sha256 cellar: :any,                 ventura:        "7d0a3805e94d526829545c6b9727ddfa2386601e4faad857b8d9b3da24d81cf9"
    sha256 cellar: :any,                 monterey:       "d9d9ec8a7898531a6c89e22fbb98a9537649a26899d3bfd0ee4352f3bd003f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4508612c1f8603d490e9947ccc09a2954a482d76f94962d6bfc18577616db52"
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
