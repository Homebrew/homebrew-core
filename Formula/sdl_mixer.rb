class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  revision 3

  bottle do
    cellar :any
    sha256 "a9d4dfcfebc9cacf6f33ac82466d284292c00cabcfe4073d7c3f9a58d4cd2f4d" => :high_sierra
    sha256 "9f15e2bce269d4ccff667f10e38eb9fb55d4468e88712501fef373663ea98c24" => :sierra
    sha256 "2f4e988e1b90a45a607a5d0d6cb43be000d16c0989a753dcb65cd1793fbeec0f" => :el_capitan
    sha256 "4aa230e9616aefcfdb64ac42bde5eec3bbb1c509963f8c526972dddfd91ad8a3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libmikmod"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg" => :optional

  def install
    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-ogg
      --disable-music-ogg-shared
      --disable-music-mod-shared
    ]

    args << "--disable-music-fluidsynth-shared" if build.with? "fluid-synth"
    args << "--disable-music-flac-shared" if build.with? "flac"
    args << "--disable-music-mp3-shared" if build.with? "smpeg"

    system "./configure", *args
    system "make", "install"
  end
end
