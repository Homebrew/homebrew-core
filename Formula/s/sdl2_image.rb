class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.2/SDL2_image-2.8.2.tar.gz"
  sha256 "8f486bbfbcf8464dd58c9e5d93394ab0255ce68b51c5a966a918244820a76ddc"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0242f47a58a78fddf9e66d71358fc2d75a0f1534d718e4b0f143e9ee9c1eead7"
    sha256 cellar: :any,                 arm64_ventura:  "56a75184dc09538f969ea4c574164a4ef0fc314961617a3702889fdd9cf4daa0"
    sha256 cellar: :any,                 arm64_monterey: "7a9834325984299278a0cf3896918e2179016c54408241be993aca2205f509c9"
    sha256 cellar: :any,                 sonoma:         "2ce178b543afe108c05798e2285caca2ddcaec28cf39d8ffec7a746d19a93ab8"
    sha256 cellar: :any,                 ventura:        "6b33e098392a868de4eab755aad6d16d0ac063afec4482467d53ba2e33939673"
    sha256 cellar: :any,                 monterey:       "328ff45a1b01e5ced1868315b2dd20db0130d7adeba401fdef07f34f86cc92a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe72a4e425543c606b9b6c30857748081f4d5fc4ff7966511e40e089e2bfd22"
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
