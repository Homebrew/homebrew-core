class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz"
  sha256 "a9eceb1ad88c1f1545cd7bd28e7cbc0b2c14191d40238f531a15b01b1b22cd33"

  bottle do
    cellar :any
    sha256 "745d9593a0e07a70b617ace17d92b6a6555825484e47e569130eba8b05e82f2b" => :catalina
    sha256 "b69ec46685ef188e9776592355447ec566a9f21979e7cb1cf24e9ce2d34e5383" => :mojave
    sha256 "c16d01a44651ad3976b32dc34a6e9b002627c9b10742be62cf341db841cd700f" => :high_sierra
    sha256 "c56396c440997b65897427479e84bc07ac4efb0b796aebe223ffc61b07b16b0e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
    system ENV.cc, "-L#{lib}", "-lsdl2_ttf", "test.c", "-o", "test"
    system "./test"
  end
end
