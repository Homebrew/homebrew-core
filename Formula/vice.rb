class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.1.tar.gz"
  sha256 "3eb8159633816095006dec36c5c3edd055a87fd8bda193a1194a6801685d1240"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "cfc6a84e02744b85867aeeef591fb185de4a8560a1fbbc7dc50a53a8d0393b59" => :high_sierra
    sha256 "39bfe0b566c65cb01ce976dbb5be3fbf46b4486bc9678f8c5b288fd2d8bb265d" => :sierra
    sha256 "34ff96ca0fdc51f4a873970d00bcab347c3483fad7ee1a670e1c49182690cd2e" => :el_capitan
    sha256 "ab4044f958907bd7d756575fc97e0e42ffc24307c621176da0d0522feadb22f4" => :yosemite
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

  def caveats; <<~EOS
    Apps for these emulators have been installed to #{opt_prefix}.
  EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end
