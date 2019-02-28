class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.3.tar.gz"
  sha256 "1a55b38cc988165b077808c07c52a779d181270b28c14b5c9abf4e569137431d"

  bottle do
    sha256 "0b76399d14543c4b7d8ef37779b2d1f79861dd2647650b8739f7f77cfaba4de5" => :mojave
    sha256 "5e4241d38f267003d787c07968e071774b6491c7969cd9df476acd25e4235dca" => :high_sierra
    sha256 "06f42f2f85f32bb8630513d7d809545e49da9e8ff9b0053a26a0b068886cee79" => :sierra
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
