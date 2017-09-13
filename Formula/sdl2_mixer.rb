class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.1.tar.gz"
  sha256 "5a24f62a610249d744cbd8d28ee399d8905db7222bf3bdbc8a8b4a76e597695f"
  revision 1
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    sha256 "c64414c8a3c09931479dcfa8d66363e7dd9e37538c1368fb890be8c2434481a0" => :sierra
    sha256 "435b75cff646b1e4c4f7f6861be2e1549bc85416b155e54bf5608db6a68cc034" => :el_capitan
    sha256 "10eebd63b6c51341966513cc8eb5160e9f5805d984d582cee2e42dad4ca3b0e7" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libmodplug" => :optional
  depends_on "smpeg2" => :optional

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix} --disable-dependency-tracking
      --enable-music-ogg --disable-music-ogg-shared
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --disable-music-mod-modplug-shared
      --disable-music-mp3-smpeg-shared
    ]

    args << "--disable-music-flac" if build.without? "flac"
    args << "--disable-music-midi-fluidsynth" if build.without? "fluid-synth"
    args << "--enable-music-mod-mikmod" if build.with? "libmikmod"
    args << "--disable-music-mod-modplug" if build.without? "libmodplug"

    if build.with? "smpeg2"
      args << "--with-smpeg-prefix=#{Formula["smpeg2"].opt_prefix}"
    else
      args << "--disable-music-mp3-smpeg"
    end

    system "./configure", *args
    system "make", "install"
  end
end
