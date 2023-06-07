class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.3/SDL2_image-2.6.3.tar.gz"
  sha256 "931c9be5bf1d7c8fae9b7dc157828b7eee874e23c7f24b44ba7eff6b4836312c"
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
    sha256 cellar: :any,                 arm64_ventura:  "f31a8a5f9fa1c0a5f4e54e1db39bcc7cb3b5b1ff4b87ddb586da69092918a6d8"
    sha256 cellar: :any,                 arm64_monterey: "35962214be840c932088cebc063866e081a0eaca94535ff0a3ef56c0bb834e13"
    sha256 cellar: :any,                 arm64_big_sur:  "b80dc377a80a3c810bf34a874ba29e7a2a4b9466147e43a71adba6e4a9dbf11d"
    sha256 cellar: :any,                 ventura:        "4c272fc2cfca1f7896e75ec309512995ec5662ebed6a5b42b9fbb4122e743e85"
    sha256 cellar: :any,                 monterey:       "77f2b55835c07bed2bd94a5b1976abb8e1cc19dcc5fac9faa9a6cd7404ef38be"
    sha256 cellar: :any,                 big_sur:        "979228e07f3e8826b07a294de300d5ac665856725030b79064250b85a365de3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811c932399df786285c0e5cf381b8075aa586e52c06216b3967afbb82a304af4"
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
