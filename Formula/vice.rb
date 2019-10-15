class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.3.tar.gz"
  sha256 "1a55b38cc988165b077808c07c52a779d181270b28c14b5c9abf4e569137431d"
  revision 2
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  bottle do
    sha256 "7cc7889e59d86aea5c5d546b2546f0d362eca98f0a3b30c6b79a0b225ff6e134" => :catalina
    sha256 "70cd1c39de3602ff4f6834bae1e2bdb084183d48dfd50559e771f91b8b13dead" => :mojave
    sha256 "93a9bd8e96d84c627e54ca142674e99fa47e8501dac887210d7afcde43d511d9" => :high_sierra
    sha256 "ec8486f012038772ef8239623f472d7c619c614194f0da67d72cadaedf10154c" => :sierra
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
