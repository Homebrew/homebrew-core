class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.3.tar.gz"
  sha256 "1a55b38cc988165b077808c07c52a779d181270b28c14b5c9abf4e569137431d"
  revision 1
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  bottle do
    rebuild 1
    sha256 "29be4c43c338b9f7d627a2dc33e1780c667b1f17149f9c606e4445f4275de3d1" => :mojave
    sha256 "1fe973b99f548b1511562e3e74fc0ad73bbce959357030d9a67c7b7fe2027c10" => :high_sierra
    sha256 "a75fe0b1bacc3d934c017cd415dc0610c70dde9d3e0a1a26eea5d449086e757f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build
  depends_on "autoconf" if build.head?
  depends_on "automake" if build.head?
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "gtk+3" if build.head?
  depends_on "jpeg"
  depends_on "lame"
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
      "--disable-bundle",
      "--enable-external-ffmpeg",
    ]

    if build.head?
      configure_flags << "--enable-native-gtk3ui"
      configure_flags << "--disable-hwscale"
    else
      configure_flags << "--enable-sdlui2"
    end

    system "./autogen.sh" if build.head?
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
