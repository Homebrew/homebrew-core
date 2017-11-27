class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.2.tar.gz"
  sha256 "4e615e27efca4f439df9af6aa2c6de84150d17cbfd12174b54868c12f19c83bb"
  revision 3
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    sha256 "c08383ce63a5db8fb8a86b1bc14fe63ef72a361eaa930abc4674d77c9f59010f" => :high_sierra
    sha256 "67e61f249d315a1612e422a5c21e852811228a8079787be4e8fc9a791c00fde8" => :sierra
    sha256 "f4d5341fddedd84477049b76ab0a85f6b0411352d26be0348fce683ae37b55b8" => :el_capitan
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
