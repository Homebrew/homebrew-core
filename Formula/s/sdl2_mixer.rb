class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.8.1/SDL2_mixer-2.8.1.tar.gz"
  sha256 "cb760211b056bfe44f4a1e180cc7cb201137e4d1572f2002cc1be728efd22660"
  license "Zlib"
  revision 1
  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f3347bd3ed1ed620a22442fdf68745fdc41077a826c390283ae178a7052a2a7"
    sha256 cellar: :any,                 arm64_sonoma:  "7a83841403100148b171146412fef906be77e6e521e5b5f3e02663e1e6be8e9d"
    sha256 cellar: :any,                 arm64_ventura: "0b350c0850302556db2f8979fa2ef3ab09f091375f06b7bb3f72fcb5751d5700"
    sha256 cellar: :any,                 sonoma:        "736465b5d143bdef9bffe19b200bd6a92f919554b2df277245efc4986f65933c"
    sha256 cellar: :any,                 ventura:       "b3586583edbbd7c50ecc3a27e8d4ce50c6c0e04f2ebdc3c434fa3fa42d85e2e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dffaed0bb10b084cad8b4cf926f7d720e33d36eab6dcbaf9d3ed492acd74c42c"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "game-music-emu"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "wavpack"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    if build.head?
      mkdir "build"
      system "./autogen.sh"
    end

    system "./configure", "--enable-music-wave",
                          "--enable-music-mod",
                          "--enable-music-mod-xmp",
                          "--disable-music-mod-xmp-shared",
                          "--disable-music-mod-modplug",
                          "--enable-music-midi",
                          "--enable-music-midi-fluidsynth",
                          "--disable-music-midi-fluidsynth-shared",
                          "--disable-music-midi-native",
                          "--disable-music-midi-timidity",
                          "--enable-music-ogg",
                          "--enable-music-ogg-vorbis",
                          "--disable-music-ogg-vorbis-shared",
                          "--disable-music-ogg-stb",
                          "--disable-music-ogg-tremor",
                          "--enable-music-flac",
                          "--enable-music-flac-libflac",
                          "--disable-music-flac-libflac-shared",
                          "--disable-music-flac-drflac",
                          "--enable-music-mp3",
                          "--enable-music-mp3-mpg123",
                          "--disable-music-mp3-mpg123-shared",
                          "--disable-music-mp3-minimp3",
                          "--enable-music-opus",
                          "--disable-music-opus-shared",
                          "--enable-music-gme",
                          "--disable-music-gme-shared",
                          "--enable-music-wavpack",
                          "--enable-music-wavpack-dsd",
                          "--disable-music-wavpack-shared",
                          *std_configure_args

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          const int INIT_FLAGS = MIX_INIT_FLAC | MIX_INIT_MOD | MIX_INIT_MP3 | MIX_INIT_OGG | MIX_INIT_MID | MIX_INIT_OPUS | MIX_INIT_WAVPACK;
          int success = Mix_Init(INIT_FLAGS);
          Mix_Quit();
          return success == INIT_FLAGS ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "-I#{Formula["sdl2"].opt_include}/SDL2",
           "test.c", "-L#{lib}", "-lSDL2_mixer", "-o", "test"
    system "./test"
  end
end
