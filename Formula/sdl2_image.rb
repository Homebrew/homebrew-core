class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.3/SDL2_image-2.6.3.tar.gz"
  sha256 "931c9be5bf1d7c8fae9b7dc157828b7eee874e23c7f24b44ba7eff6b4836312c"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d8cf29c641b4449b888028d69b6b4ffaf2821aaf31971ddba794dcf562810c6"
    sha256 cellar: :any,                 arm64_monterey: "1be70a8f34906619fa0ec3d93e7fd21e89ae1bc0d71af6db2110218adeb7dc99"
    sha256 cellar: :any,                 arm64_big_sur:  "5bf7d9ef30ebd8d5beebc20c2f7b731feefcb491c9e0390a31829e178ab88415"
    sha256 cellar: :any,                 ventura:        "2ccadb87709282d613473d12d34f5227bd416cab9e731eda85eaa9a391379a4d"
    sha256 cellar: :any,                 monterey:       "2961b465fd3e68bd7cd31b8ad14e1213b1d674a893ef4a7242ef2fefa91e0fab"
    sha256 cellar: :any,                 big_sur:        "12db1954b7e6fdf237df73f3aa30e5d563364972a47387a4556620e21b36a285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e331576551986ece36222101ae07414e3ae55cdf8073f84caa2afa8ad4cf1b"
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
