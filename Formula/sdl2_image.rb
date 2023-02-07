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
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2e1fc4ff5b35ebb029144dffa589e00c47655b5a38761e5b8aed576dccf47d3"
    sha256 cellar: :any,                 arm64_monterey: "5d4dd6f2ac73e848ce15289e4cbcc35d9a403831ae90e3416d5bf042b8a3bb19"
    sha256 cellar: :any,                 arm64_big_sur:  "bc92dddcc7f1699056f1ce13d7b743a23397bf04e71a241a92e814812670fc3b"
    sha256 cellar: :any,                 ventura:        "cd8c6f643593b9b1f693b6a862f6b74a3f4cb20432f6410914c4d346af7dae5f"
    sha256 cellar: :any,                 monterey:       "d1f76d290e018fccb9f71fe1c1b9bf20058c66e7085046f17691468b027220a0"
    sha256 cellar: :any,                 big_sur:        "9e5715b292bd163889dc46203a6381a80d1d3b15e26d26419d68ef1385cabdc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867e38018f04dbd154e2bfc1fec08306d993f89d251788423deadc3bc4e2912b"
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
