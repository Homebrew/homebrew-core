class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.8.1/SDL2_mixer-2.8.1.tar.gz"
  sha256 "cb760211b056bfe44f4a1e180cc7cb201137e4d1572f2002cc1be728efd22660"
  license "Zlib"
  revision 1

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29131b712fd63e8085fd10d1e158e8c4eff11ee363b0b3768ab8f0ab9d26c5cc"
    sha256 cellar: :any,                 arm64_sequoia: "1c7c1592895fc8bc86a246445698cd3258f835e319a4017d596ae8d67966d605"
    sha256 cellar: :any,                 arm64_sonoma:  "2203b3fe60c59ca2f77fed180fb25598c083bfc25baff79bd84ffea16fa12623"
    sha256 cellar: :any,                 arm64_ventura: "bc6a8a9f8e3b8f145873f2f18d428549286923304887c75eae9e0c6153b9f8cd"
    sha256 cellar: :any,                 sonoma:        "2a0833b4e5b3d6b5e650e6260ea32fe5f07a9fa4ed66a8f4343d5d9c65c26f9e"
    sha256 cellar: :any,                 ventura:       "721f0f56d5b954e4e5cc484fa4046712b2099aafa4849091772aae71afb19145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1179824f595c247ae0bd213a9af93d973f17b068fdcac3017ec2431196eba023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7022d2cdf02890e277cf56cfa6e15e5940a000886b92991027b8efbf8332927"
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
