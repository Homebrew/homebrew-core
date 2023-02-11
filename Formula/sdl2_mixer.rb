class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.6.3/SDL2_mixer-2.6.3.tar.gz"
  sha256 "7a6ba86a478648ce617e3a5e9277181bc67f7ce9876605eea6affd4a0d6eea8f"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87aacc15b9b3f376868ae010adf45fc77c9e8ea225f005b00e2f9e8e628dbe80"
    sha256 cellar: :any,                 arm64_monterey: "04cf6823246e7db7b7732b50b2a22ccb52260cb4fad7500e1919744112098859"
    sha256 cellar: :any,                 arm64_big_sur:  "794648b3c66dbd4d3eafb8657e3236fb2e11209000e16fde24758481d19577c0"
    sha256 cellar: :any,                 ventura:        "1ac0fca1270e608ee716c9861e2ebfc5e9bed8b19fc92611dd0173276475be5e"
    sha256 cellar: :any,                 monterey:       "5dd18dc4715a34882435d4f9cf9fbadcaa437bdfd3139fa4262fe34c7cc467bd"
    sha256 cellar: :any,                 big_sur:        "0c27a68d5a7918dcfb9c3fbff4f49439bf44566fb24bfad531143db831c2bf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68898214e734c6c85a3a1589575dec299550435db9c224d352fdb9b86955e59b"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "opusfile"
  depends_on "sdl2"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    if build.head?
      mkdir "build"
      system "./autogen.sh"
    end

    system "./configure", *std_configure_args,
      "--enable-music-wave",
      "--enable-music-mod",
      "--enable-music-mod-xmp",
      "--disable-music-mod-xmp-shared",
      "--disable-music-mod-modplug",
      "--enable-music-midi",
      "--enable-music-midi-fluidsynth",
      "--disable-music-midi-fluidsynth-shared",
      "--disable-music-midi-native",
      "--disable-music-midi-timidy",
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
      "--disable-music-mp3-drmp3",
      "--enable-music-opus",
      "--disable-music-opus-shared"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          const int INIT_FLAGS = MIX_INIT_FLAC | MIX_INIT_MOD | MIX_INIT_MP3 | MIX_INIT_OGG | MIX_INIT_MID | MIX_INIT_OPUS;
          int success = Mix_Init(INIT_FLAGS);
          Mix_Quit();
          return success == INIT_FLAGS ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "-I#{Formula["sdl2"].opt_include}/SDL2",
           "test.c", "-L#{lib}", "-lSDL2_mixer", "-o", "test"
    system "./test"
  end
end
