class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.1.tar.gz"
  sha256 "3eb8159633816095006dec36c5c3edd055a87fd8bda193a1194a6801685d1240"

  bottle do
    cellar :any
    sha256 "c255b84b7f49014481ba0a1b43a921d65c43040a84c1d5d9a89d0ff19a0709bf" => :sierra
    sha256 "97a15bc32da4619365dfe21063686c628117753354a718fe04d19953273a60a1" => :el_capitan
    sha256 "59033f7b07d827fe31adf64eb85d88594d7b49bd89c47b00a6762fb4171f84ad" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "portaudio"
  depends_on "sdl2"
  depends_on "xz"

  # needed to avoid Makefile errors with the vendored ffmpeg 2.4.2
  resource "make" do
    url "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
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

    # Upstream recommends using SDL/SDL2 as Cocoa is essentially unsupported.
    # Use a static lame, otherwise Vice is hard-coded to look in
    # /opt for the library.
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sdlui2",
                          "--without-x",
                          "--enable-external-ffmpeg",
                          "--enable-static-lame"
    system "make"
    system "make", "bindist"
    prefix.install Dir["vice-macosx-*/*"]
    bin.install_symlink Dir[prefix/"tools/*"]
  end

  def caveats; <<-EOS.undent
    Apps for these emulators have been installed to #{opt_prefix}.
  EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end
