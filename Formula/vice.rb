class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.4.tar.gz"
  sha256 "4bd00c1c63d38cd1fe01b90032834b52f774bc29e4b67eeb1e525b14fee07aeb"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  bottle do
    sha256 "ab60f8d6ed6e48190ae40464b449578141326e56006e422e46b85525f0876fec" => :catalina
    sha256 "8774f17d04f9f3967886123347151705b1e53d0d3d55328ba553d60f1a73747b" => :mojave
    sha256 "009af174f99daedad8b319cef9668f07d7c513fa8a859a687ef731a3e2a1abf7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "gtk+3" if build.head?
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libnet"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "sdl2" unless build.head?
  depends_on "xz"

  def install
    configure_flags = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--disable-arch",
      "--enable-external-ffmpeg",
    ]

    if build.head?
      configure_flags << "--enable-native-gtk3ui"
    else
      configure_flags << "--enable-sdlui2"
    end

    system "./autogen.sh"
    system "./configure", *configure_flags
    system "make", "install"
  end

  def caveats; <<~EOS
    App bundles are no longer built for each emulator. The binaries are
    available in #{HOMEBREW_PREFIX}/bin directly instead.
  EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end
