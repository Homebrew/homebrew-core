class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.6.3/SDL2_mixer-2.6.3.tar.gz"
  sha256 "7a6ba86a478648ce617e3a5e9277181bc67f7ce9876605eea6affd4a0d6eea8f"
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
    sha256 cellar: :any,                 arm64_ventura:  "c043dc385f650b3e3724a7095113ee5fbf573486a0b2611c5dfb721ee63774ed"
    sha256 cellar: :any,                 arm64_monterey: "904d0603c8b469af83ed67a29be09a7e762109c284ea154b788c6fafcf49ffa2"
    sha256 cellar: :any,                 arm64_big_sur:  "c682563d2f4a9cabc9658f787e4514072883227e1974139600e23c841556418b"
    sha256 cellar: :any,                 ventura:        "32ee9039da185a509b83bef2b516d7cc2abe6e90272cdede82dbb028c22bce7b"
    sha256 cellar: :any,                 monterey:       "d6da5c475e9790af0c7c1c7f4650eabb5512696a0fb1e50f62915cc75c8d7ca6"
    sha256 cellar: :any,                 big_sur:        "64d6f21fc6e6a0cd02d4faddfe32c7daf42ce7abff31ce858515b0bcc08c160e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b7c2f966442b5364127e4ed065b1bb77b15e27f01cc4bc171a59b26aecaef73"
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
