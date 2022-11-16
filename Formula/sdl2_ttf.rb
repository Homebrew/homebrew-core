class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.20.1/SDL2_ttf-2.20.1.tar.gz"
  sha256 "78cdad51f3cc3ada6932b1bb6e914b33798ab970a1e817763f22ddbfd97d0c57"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "965b06109282c56c513b3836bdced71d34c7b532b42a5a0fad1188cb171f12f1"
    sha256 cellar: :any,                 arm64_monterey: "0717a73e3b400b75d4c95a1f041405d1e2a51d853084f4f4a2df509a0f5f66b4"
    sha256 cellar: :any,                 arm64_big_sur:  "3c330912742dc8adec3f1c84d72cd0c6d2042e07668b4e0949dd19a48db93399"
    sha256 cellar: :any,                 ventura:        "e0801a169bc31d6340a5c6f57b289d92099449a43ae7a2f422356a85ec39a47a"
    sha256 cellar: :any,                 monterey:       "03664994cfddf5b0dc3c2e17882ac02d01e2f46f0c74b711cdaf8b850e97c721"
    sha256 cellar: :any,                 big_sur:        "1d882966dfe5f2710325b20c9aaa3dc37e4fdc2698c8fb9f3d4252a62a3799be"
    sha256 cellar: :any,                 catalina:       "b969e2ec3520ce18c9ab44e05e9fb4e406887c8d879d156c8eedc559ba9bfe30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69cd455ca76baafa15a74f4266c6dc5b3531c5146a7d420beeeae2e106ebdfc1"
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
