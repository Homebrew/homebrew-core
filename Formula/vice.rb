class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.3.tar.gz"
  sha256 "1a55b38cc988165b077808c07c52a779d181270b28c14b5c9abf4e569137431d"
  revision 1
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  bottle do
    sha256 "b0ef45d4c1658cd3aa7b42b71ec1d2e5f30abd4f0e0fa7703adb2690e2af22a5" => :mojave
    sha256 "7329a08c140b193c56d6225a37b8627d10e5a972dbe982d0eb581d2105d75b89" => :high_sierra
    sha256 "9bbf231068988591d65da218577efeb757d747f36d43c70a28bdbe22bad9b4ac" => :sierra
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
