class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.8.2/SDL2_mixer-2.8.2.tar.gz"
  sha256 "938dff531d00ace2296557a6599abe6f34599e2f34f0a4a08a397e2ccac8b8f7"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b51467b14224893388dbda5a3154fcd29d63f02fb0810b2aa08844b51b77530e"
    sha256 cellar: :any,                 arm64_sequoia: "c73b68187c3784df0ca2dfccb296db4b0e87c969dc80a32e27b13cbf79a146fb"
    sha256 cellar: :any,                 arm64_sonoma:  "ad750989fe0eeceba6d243009c69b02ca9b9da25732d4d562da30d0859ff6a7c"
    sha256 cellar: :any,                 sonoma:        "0991d538a75bde3e9adae424c2ffad5e75a2b486a435c54954c2a1e902f78109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95d2d530adf0c579f1de62a333acd261725e050d31e5f28883d7efc09d83df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db7991de483573122d63b0c503a1e7c660535f7e36864dc8e8ac0668b239d53"
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
