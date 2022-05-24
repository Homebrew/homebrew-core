class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  license "Zlib"
  revision 3

  stable do
    url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
    sha256 "b4cf5a382c061cd75081cf246c2aa2f9df8db04bdda8dcdc6b6cca55bede2419"

    # Fix fluidsynth use-after-free bug until the release after 2.0.4, upstream patch
    # https://github.com/libsdl-org/SDL_mixer/commit/6160668079f91d57a5d7bf0b40ffdd843be70daf
    patch :p3 do
      url "https://github.com/libsdl-org/SDL_mixer/commit/6160668079f91d57a5d7bf0b40ffdd843be70daf.patch?full_index=1"
      sha256 "73e5ebf9136818b7a65f1e8fcbeb99c350654d7d9e53629adc26887e9e169d8d"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_mixer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "efb9299c264820950d859c9500bc6b29f8bca49f811a2463f8fc410abc75df78"
    sha256 cellar: :any,                 arm64_big_sur:  "93f0cc1c49c8dc01ca2a8765f2b798ae733c1a6f07a16df45eba1015d1f6df02"
    sha256 cellar: :any,                 monterey:       "9a03671374b854ec1b8bc010883def60e47d92c88208a6ab01c23b8707aed65c"
    sha256 cellar: :any,                 big_sur:        "b0db96bcf83bd87c40fe9695c71ab569dba29d4cc82519cf180f7c74f8cb6721"
    sha256 cellar: :any,                 catalina:       "c4ecc918adf85671134ab3bd631a1023587ab21c03da5688850d0c29e9e1600c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "433d1c19c9da31181c772349fe65589f3485700e5e028ea59eb3ae1fc6508f70"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmodplug"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "sdl2"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    if build.head?
      mkdir "build"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-flac
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --disable-music-mod-modplug-shared
      --disable-music-mp3-mpg123-shared
      --disable-music-ogg-shared
      --enable-music-mod-mikmod
      --enable-music-mod-modplug
      --enable-music-ogg
      --enable-music-mp3-mpg123
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          int success = Mix_Init(0);
          Mix_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-I#{Formula["sdl2"].opt_include}/SDL2",
           "test.c", "-L#{lib}", "-lSDL2_mixer", "-o", "test"
    system "./test"
  end
end
