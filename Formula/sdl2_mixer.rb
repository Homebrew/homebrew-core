class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.1.tar.gz"
  sha256 "5a24f62a610249d744cbd8d28ee399d8905db7222bf3bdbc8a8b4a76e597695f"
  revision 1
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    sha256 "04d9e57c8daeede86c1e566d361ed14919898f9fe0e67e7b5c84b35e5b82e4f6" => :sierra
    sha256 "4c63b972ec35dd92dc7d39a901aca46d2108fb8cfa74b6ff9b244bc2fe21b5a6" => :el_capitan
    sha256 "ff8cbe8c234afe384813837bda9eabeb93ee488c8114437ad6e8eb0ea3497be4" => :yosemite
    sha256 "88f7ef2099f2261534cb4f3e33d65132243b36fb4a6efa648fcbba34ec6c0b77" => :mavericks
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
