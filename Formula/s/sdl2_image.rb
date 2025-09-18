class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.8/SDL2_image-2.8.8.tar.gz"
  sha256 "2213b56fdaff2220d0e38c8e420cbe1a83c87374190cba8c70af2156097ce30a"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24eb58621bff82467e5bc9331d8eb6d31fff6765612aea5c143861f5e3e472ba"
    sha256 cellar: :any,                 arm64_sequoia: "ce895628c0e84843740799c0001d8097cc5bb424edb45f150ee10d33d9031288"
    sha256 cellar: :any,                 arm64_sonoma:  "1655c170513f87b2bddc7cf740ff876d8dce6db804ca961ea94a5805aee6b495"
    sha256 cellar: :any,                 arm64_ventura: "57d15c79fb8f64048038e6dfc079805751275bdfc83baa9d14cedd10ea9034b5"
    sha256 cellar: :any,                 sonoma:        "5ced16f1eb8d4c522a1ad4e9fd3021f8441b517be78f9ccb5433815b069220c2"
    sha256 cellar: :any,                 ventura:       "25a9eec92d2e56b6edcd10ddefd0bfba6cb2fab1c6ed775886e5c91092e8c8dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fc8b292bc57169a20c3128cd1f583efc51215df9912f42636fb8ca5aa3c2505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57196690a97f3513f2a57897c5ecd6972b3d162ec42a68960768dab89d76fbf0"
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
  depends_on "sdl2"
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
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
