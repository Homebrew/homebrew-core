class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.20.2/SDL2_ttf-2.20.2.tar.gz"
  sha256 "9dc71ed93487521b107a2c4a9ca6bf43fb62f6bddd5c26b055e6b91418a22053"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb64334ebf36c5a6a5b0668ff672b3e8001cbb7c11c90dc72a0757639faed8c7"
    sha256 cellar: :any,                 arm64_ventura:  "5f983f0da784459c3a66961a6fd04e0effc138f97348e1c56ae7cfd212fc8e71"
    sha256 cellar: :any,                 arm64_monterey: "385e2291198fa3abc69205bdfd94f2fafec6ccfe3feff9a099b9dfb3e1b1d538"
    sha256 cellar: :any,                 arm64_big_sur:  "6103dbe192fad39f18e2d5a32fc29ed5753990e775aa9c06cd429a9b6eaa03fb"
    sha256 cellar: :any,                 sonoma:         "ffee2edd76bb4c736298270945a89556e814004a858c0a6461ae955f127d3bc4"
    sha256 cellar: :any,                 ventura:        "c7c57b3c4f57695953430d6b0644f941aaee275cc39d299aac6f34b2dad4ecc2"
    sha256 cellar: :any,                 monterey:       "53f332eeda518a32d032ec9cb4a934cd320b5923c480e6985dc15f4e68b1cce5"
    sha256 cellar: :any,                 big_sur:        "3c3c04cd964f3372ba28b4fd885e25a6b2f54a0e29f5db936e711691db2a72de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6dda4ea5a025a96d47ed5db5537cee2d471042437274c83c9bb97276ac1d84b"
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
