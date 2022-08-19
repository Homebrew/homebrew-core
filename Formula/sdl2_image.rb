class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.2/SDL2_image-2.6.2.tar.gz"
  sha256 "48355fb4d8d00bac639cd1c4f4a7661c4afef2c212af60b340e06b7059814777"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e59dc27bcf434af711b10014c47cf901bb8662707c13aaa126f29c1682890dd0"
    sha256 cellar: :any,                 arm64_big_sur:  "1ae1702b4cc318f66d59d9d44f17564dcdd458150dfff1a2638474f1387d33f9"
    sha256 cellar: :any,                 monterey:       "54d135e09c9d3a4d1c2079c68ed64873a30adcf7a6fe11bfe34b9680073f927f"
    sha256 cellar: :any,                 big_sur:        "87b24afb1954cc273aa0c444e0af783aaaaa7dac950c3814780f8fa8eb3de2a8"
    sha256 cellar: :any,                 catalina:       "889798afc621891fded420fa508c0fc0dac3ae01e117db6fd5d2aaf737197956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7a7512ccc84c875887060836485d38b37e83f7b8b2beb8c30342989a21c467a"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args,
                          "--disable-imageio",
                          "--disable-jpg-shared",
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
          int success = IMG_Init(0);
          IMG_Quit();
          return success;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
