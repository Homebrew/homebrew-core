class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.2/SDL2_image-2.8.2.tar.gz"
  sha256 "8f486bbfbcf8464dd58c9e5d93394ab0255ce68b51c5a966a918244820a76ddc"
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
    sha256 cellar: :any,                 arm64_sequoia: "ea6594c3fe00a6b0a1169f68e78ef17c0d9cc35dab208d88e2b448cf96703547"
    sha256 cellar: :any,                 arm64_sonoma:  "4520a781a18de69c48f4e45cdf0136facce70322d326200eac0568ea06d9b0de"
    sha256 cellar: :any,                 arm64_ventura: "d6ba44f75c244195f45458679b1ffcbde7ba4041b0ac314608b1ca66719ce5c5"
    sha256 cellar: :any,                 sonoma:        "b77136bb7cac65db0092fba3c4f06ac8af0d3eb273dc98e4a0dc36773f341fc9"
    sha256 cellar: :any,                 ventura:       "6c47414b1e8b5c656e8aa1dd07529e6510df854f0ddb0d630a8e25b557244e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627c063738ce664e38f5eaec55821203a6388ce4559f4b3427468aaf9bed4a97"
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
