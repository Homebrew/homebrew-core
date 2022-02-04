class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.0.18/SDL2_ttf-2.0.18.tar.gz"
  sha256 "7234eb8883514e019e7747c703e4a774575b18d435c22a4a29d068cb768a2251"
  license "Zlib"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "01abc453be483984acdcc80e8e9d3f1ce880a6b06344e8c96295e29935148458"
    sha256 cellar: :any,                 arm64_big_sur:  "c3829e2aff4e9137a1f9dbb72f39aed6b097960c3fd204163ba3bce44f5e0e32"
    sha256 cellar: :any,                 monterey:       "7672ccbe096152da61a813a2870887fef6076031679616e4ba42888007d88fc3"
    sha256 cellar: :any,                 big_sur:        "93155231163ee6ebd5d7c36c859341629ce96abfb8d0ca00aa928e3b219128d9"
    sha256 cellar: :any,                 catalina:       "f0aadd0fa8f1dedc706efac6e361dad6cae614413357e4ab3150a57bd766bb4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5e495a8ec43101ee5a4387710de8103caf1f24a8c09d52a27d245089de0ec4"
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
