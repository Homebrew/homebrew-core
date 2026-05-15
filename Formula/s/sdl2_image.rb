class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.12/SDL2_image-2.8.12.tar.gz"
  sha256 "393f5efb50536ec13ca4f4affb69cc9966d3c3f969e6c5e701faddf9f9785381"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44d60e4ad85cd8a523c3cb25d87ac2fb8527986020c98fb80d3f50af3cbdaa4e"
    sha256 cellar: :any,                 arm64_sequoia: "4948e7e20579f5b09a6da7d3735fcbe1bfd93d4325ef4f21fcb721186a0bb006"
    sha256 cellar: :any,                 arm64_sonoma:  "51c3b7f2d372a2d3423a016083f1759412875a361d122f4d0ec28a0f09dc3484"
    sha256 cellar: :any,                 sonoma:        "d8ddeea0976fccf8f5863a52d2fc02a15ee95cd1de8cb31d7108342cb63643d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21edf97cb5f6b3c2677c721dbf080a6931d4baf433be6d1d883622da3d11f1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e397bd44467abfcdc1f26b03d3c217a5c5ce711f266deddcadd9f12c1efddd"
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
