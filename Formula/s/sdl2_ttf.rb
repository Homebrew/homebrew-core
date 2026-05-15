class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.24.0/SDL2_ttf-2.24.0.tar.gz"
  sha256 "0b2bf1e7b6568adbdbc9bb924643f79d9dedafe061fa1ed687d1d9ac4e453bfd"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7464ed639413ddbf1b581564c07bab5d3a45325ab44619ac810af3361f3f7ab8"
    sha256 cellar: :any,                 arm64_sequoia: "15e7d2771f3011e7acc050c32642eb312e96b51596300562a9f6395669608779"
    sha256 cellar: :any,                 arm64_sonoma:  "63163b41f4746695229e47cdf721975c8d03ea0809f924c8434389e38912e186"
    sha256 cellar: :any,                 arm64_ventura: "50e4a60835bd4eb6437e7612f39e40f9377f555ef8046c8a465b622adfbcedaa"
    sha256 cellar: :any,                 sonoma:        "601eca4a716530bd0758865775581bb82f581c5a728df398231a0e4ba9b3071f"
    sha256 cellar: :any,                 ventura:       "effa9785cf42d097925fc27008e432f279aa519c11f48cfd98ee942301d15a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548921f9bab6e4907a934102c2b31492a8fd488aac72ad7b35c2010c64978c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "482786481f8a3f5a8f6f147156f5af9cd192e43e2d5b6adf3a5914bcc53bc1cc"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    (testpath/"test.c").write <<~C
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_ttf", "-o", "test"
    system "./test"
  end
end
