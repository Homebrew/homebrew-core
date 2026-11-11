class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.12/SDL2_image-2.8.12.tar.gz"
  sha256 "393f5efb50536ec13ca4f4affb69cc9966d3c3f969e6c5e701faddf9f9785381"
  license "Zlib"
  revision 2
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "94c3a842c63996b271c6c6571e809cfc3d0382b3e87650ea198635c0ccad8edf"
    sha256 cellar: :any, arm64_tahoe:       "5be50d7cb3c3f91fdf5a7b9dcab8d034c811103bce8f1d4f48009afec59dc4a3"
    sha256 cellar: :any, arm64_sequoia:     "e73feaab1d1de793669c299620346dd1b6f126834aab3c9efac01d3bcfb66efd"
    sha256 cellar: :any, arm64_linux:       "eae08400b9b6fa326b70e45470a0559616e67f52c14eb8062d841ebda6a7fdc1"
    sha256 cellar: :any, x86_64_linux:      "057ee12f097549b27c32c6ecd1a5d6288f1d29de699f7b823a5a893d78abd578"
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
  depends_on "sdl2-compat"
  depends_on "webp"

  deny_network_access!

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
    system ENV.cc, "test.c", "-I#{formula_opt_include("sdl2-compat")}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
