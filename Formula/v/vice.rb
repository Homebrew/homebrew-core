class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.9.tar.gz"
  sha256 "40202b63455e26b87ecc63eb5a52322c6fa3f57cab12acf0c227cf9f4daec370"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "3233bcda97a1a7daab6ae5189b535ee872174ea804be74d3dbd3197d55ff0c7d"
    sha256 arm64_sequoia: "8b78df5935aab1f83e0207ea2f728b96a74e66d69f5299e8507f990f11920822"
    sha256 arm64_sonoma:  "729bb747eeb23ff89b1cb604520e7204880394934d91f316c9dc7aeef2f7f73f"
    sha256 arm64_ventura: "076944a3a5d61b727aaa53724661d96a975f22092da741c06db0ab0a4d2a8adc"
    sha256 sonoma:        "214a47453e12ef15db2adc4cece96aca944ae2dc4b785166bf5e6dc96323d621"
    sha256 ventura:       "550d23369b47768525c093b7b7e7f7d737488060bef4e69919685a1dfdaf5c56"
    sha256 arm64_linux:   "ab0b2b09715f4ef67be4be7dbf0eacea5a49211cfa2b7704759c0be64e3b6229"
    sha256 x86_64_linux:  "752515da593a5bbddd5ab728ecba2bab8a5ae79ec449cd5471de3c2854ce893e"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "pulseaudio"
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
                          "--without-evdev", # TODO: needs libevdev
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000", 1)
    assert_match "Initializing chip model", output
  end
end
