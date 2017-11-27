class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.2.tar.gz"
  sha256 "4e615e27efca4f439df9af6aa2c6de84150d17cbfd12174b54868c12f19c83bb"
  revision 3
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    sha256 "294939d7e15b8e173e9d52dc2abfedec5c49d42f98a806db3fa5277f464202b1" => :high_sierra
    sha256 "6551ecd136aa19fec2a6e6234f34da4a4ffe6d0a5ed2461e7e0cd184f76ba45e" => :sierra
    sha256 "effd6b19570fca9ee6c57483f96cc87cc48fe308bc272a9dffee66e68c77a793" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "libmikmod" => :optional
  depends_on "smpeg2" => :optional

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix} --disable-dependency-tracking
      --enable-music-ogg --disable-music-ogg-shared
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --enable-music-mod-modplug
      --disable-music-mod-modplug-shared
      --disable-music-mp3-smpeg-shared
    ]

    args << "--disable-music-flac" if build.without? "flac"
    args << "--disable-music-midi-fluidsynth" if build.without? "fluid-synth"
    args << "--enable-music-mod-mikmod" if build.with? "libmikmod"

    if build.with? "smpeg2"
      args << "--with-smpeg-prefix=#{Formula["smpeg2"].opt_prefix}"
    else
      args << "--disable-music-mp3-smpeg"
    end

    system "./configure", *args
    system "make", "install"
  end
end
