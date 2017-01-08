class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "http://vice-emu.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.0.tar.gz"
  sha256 "bc56811381920d43ab5f2f85a5e08f21ab5bdf6190dd5dfe9f500a745d14972b"

  bottle do
    cellar :any
    sha256 "1734a97e9772b5b42cd917628094240b24ddcf21e68910e8e1107274a1f9275a" => :el_capitan
    sha256 "b64f33472ea5655c1aac3795b79d99b14738c28642c0cf21d9708441d02323ef" => :yosemite
    sha256 "05446f9614d5ee6170cd2d323ad24289a0312ac42a5f2ec575200036513731b1" => :mavericks
    sha256 "de32b3004dbc9a1dad21a546c983ba55d3559eae78f898a54be96c8f2c278b3b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "yasm" => :build
  depends_on "flac"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "portaudio"
  depends_on "xz"

  # needed to avoid Makefile errors with the vendored ffmpeg 2.4.2
  resource "make" do
    url "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
    sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"
  end

  def install
    resource("make").stage do
      system "./configure", "--prefix=#{buildpath}/vendor/make",
                            "--disable-dependency-tracking"
      system "make", "install"
    end
    ENV.prepend_path "PATH", buildpath/"vendor/make/bin"
    ENV.refurbish_args # since "make" won't be the shim

    # Fix undefined symbol errors for _Gestalt, _VDADecoderCreate, _iconv
    # among others.
    ENV["LIBS"] = "-framework CoreServices -framework VideoDecodeAcceleration -liconv"

    # Use Cocoa instead of X
    # Use a static lame, otherwise Vice is hard-coded to look in
    # /opt for the library.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cocoa",
                          "--without-x",
                          "--enable-static-ffmpeg",
                          "--enable-static-lame"
    system "make"
    system "make", "bindist"
    prefix.install Dir["vice-macosx-*/*"]
    bin.install_symlink Dir[prefix/"tools/*"]
  end

  def caveats; <<-EOS.undent
    Cocoa apps for these emulators have been installed to #{prefix}.
  EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end
