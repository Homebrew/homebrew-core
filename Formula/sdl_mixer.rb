class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  revision 2

  bottle do
    cellar :any
    sha256 "568e373cf4e876779e63e36258be20c0e6acb6df81a81653ff09cb9b09deca99" => :sierra
    sha256 "e2398010d90664403b7f9c306b46876deec07e6d970371a47c7f7484ffa201f8" => :el_capitan
    sha256 "559377bb70595dc716d1f0c703e986ea4bc30666085812756230b00194b97d87" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg" => :optional
  depends_on "libmikmod" => :optional

  def install
    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-ogg
      --disable-music-ogg-shared
    ]

    args << "--disable-music-mod-shared" if build.with? "libmikmod"
    args << "--disable-music-fluidsynth-shared" if build.with? "fluid-synth"
    args << "--disable-music-flac-shared" if build.with? "flac"
    args << "--disable-music-mp3-shared" if build.with? "smpeg"

    system "./configure", *args
    system "make", "install"
  end
end
