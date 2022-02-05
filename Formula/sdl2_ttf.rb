class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.0.18/SDL2_ttf-2.0.18.tar.gz"
  sha256 "7234eb8883514e019e7747c703e4a774575b18d435c22a4a29d068cb768a2251"
  license "Zlib"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "28d5056700c673afc9015cc76ac7db652ed0a916399246e432ba5e2bcb8a09c3"
    sha256 cellar: :any,                 arm64_big_sur:  "bd4b97e8b2aa48eb25a9d02c974ce4c22677424554609aa1206aa06da83d389c"
    sha256 cellar: :any,                 monterey:       "5d772f784a63098751c71bb1a353ea329a7e491b7e4a5b99e8d9352248d95228"
    sha256 cellar: :any,                 big_sur:        "9b718acaa1960181907a0830c383aea817ed12e894d8fe8827214e76c3f06d63"
    sha256 cellar: :any,                 catalina:       "90eec1f51b053c9c8b58f808b0e185ae08c44ef7aca41449531c4c617b6d297e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc8925d5cae9a76e69fd9f928d22b7a2fc30801cfeb3964b166b01c0160e4a1"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    # `--enable-harfbuzz` is the default, but we pass it
    # explicitly to generate an error when it isn't found.
    system "./configure", "--disable-freetype-builtin",
                          "--disable-harfbuzz-builtin",
                          "--enable-harfbuzz",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_ttf", "-o", "test"
    system "./test"
  end
end
