class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.3.tar.gz"
  sha256 "1a55b38cc988165b077808c07c52a779d181270b28c14b5c9abf4e569137431d"

  bottle do
    sha256 "839f956c6df837517be09f0e116b0d30f15573f66258f981f30282951d40af0c" => :mojave
    sha256 "03585bb63878bb240fb540ef0758574cc0f9824ecd2c3c49cd0f02287970c3d2" => :high_sierra
    sha256 "7f63bc393d4ad8532c02f11214d43c7523a57fc72e58d96c3f25f074b762cf1a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "sdl2"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-arch",
                          "--disable-bundle",
                          "--enable-external-ffmpeg",
                          "--enable-sdlui2"
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
