class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.5.tar.gz"
  sha256 "bdd5f6e026682f7d7e1be0b6051b209da2f402a2dd8bd1c4bd9c25ad263108d0"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_image[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "180b64296c90fe9587a88efa1a607d939bb4dbb127f31a38193d894c5da9bfeb"
    sha256 cellar: :any,                 arm64_big_sur:  "2a4cd10f3598553180559df330435f359703eaa02a77c12bf9667d953fa2b5a3"
    sha256 cellar: :any,                 monterey:       "76025ad6b76597ef5f1f9bafa729ab8a88f94cab607a9114353be2eddf36bb34"
    sha256 cellar: :any,                 big_sur:        "d106f96771895c1b6faa9864e3605d301cdbe658672900108605c521616a8bf6"
    sha256 cellar: :any,                 catalina:       "691d5407fef2bc374ac3b7c2fafbe46a6bc0f9ed609f98812b24fec33ab9bd27"
    sha256 cellar: :any,                 mojave:         "1b3a464579d9ef25b3bdd9276119efffd0134fda5c5dc27051a35f1b21c00cfd"
    sha256 cellar: :any,                 high_sierra:    "55c1f996fb523c2727d2b103f0a5ecfd7a073f55ff9a7230bb609d22bbf5a576"
    sha256 cellar: :any,                 sierra:         "e3c9cf45d97099e818c667d23af8352e6d1bba0e3b609cdddee654f2a9da80cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "862dee72c17699cb5d0014116b98ae4de3998eead5bed93063d84b2b430147a5"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
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
