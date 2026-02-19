class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.10.tar.gz"
  sha256 "8e5bac18cbcb9f192380ad3ef881f8790f5b75c41d7b3da65d831985d864d6d1"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "6418080055eb645bc56525d0d902c9df649addb24ff8cef9756c149e6cfdbb29"
    sha256 arm64_sequoia: "f174235f11f4a31dbcfe8e5d1ca149c2b0b925db9783b35d82fb1a63e6d7c664"
    sha256 arm64_sonoma:  "eefe51be44c3fe3f8e82fdcbd5ece73f7ca1d00e4b6d6da3fdf090fc62defecb"
    sha256 sonoma:        "58fd2917eb22933c25ee8584e29972b2f6cf7b79f1a8acf050db0a570f6875f3"
    sha256 arm64_linux:   "1e99deba75899f6d0dfe9e4f0a85f3a8b1fecb983f6a4048c0c47f4aea7d82e3"
    sha256 x86_64_linux:  "76eb6cfb7a1b879a8c6ee4fa2fdcfd72312d646b574262d8a48a1742fbb5c8b0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "flac"
  depends_on "gdk-pixbuf"
  depends_on "giflib"
  depends_on "glew"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"
  depends_on "pango"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libevdev"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh"

    system "./configure", "--disable-arch",
                          "--disable-pdf-docs",
                          "--enable-gtk3ui",
                          "--enable-midi",
                          "--enable-lame",
                          "--enable-ethernet",
                          "--enable-cpuhistory",
                          "--with-flac",
                          "--with-vorbis",
                          "--with-gif",
                          "--with-png",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000", 1)
    assert_match "Initializing chip model", output
  end
end
