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
    sha256 arm64_tahoe:   "72d2956c691be19c7fd2d3cabf5bdbdfeba7e3f82f025f6084463190f27d4b60"
    sha256 arm64_sequoia: "0aca55924f4d7159a30dd60eff038d3a6d2c16fc001a637629953e841a1ddd72"
    sha256 arm64_sonoma:  "d1c1f2e7b41ef6bce878be69e1d6f8593a0b3ffee382ec723a503876534c0687"
    sha256 sonoma:        "f32364d8cd6e0d0f3c31c8b91b1c82580c3876c71119ceb2ec846b912b1976ac"
    sha256 arm64_linux:   "d547ce42a42763a57e038f1a5380993add37ad9862474798d07f79efbfb1937e"
    sha256 x86_64_linux:  "a51a3fefb5be0361e45f40723625546194d48fdab926b0ded6ff7cad886d84cb"
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
    depends_on "libevdev"
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
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000", 1)
    assert_match "Initializing chip model", output
  end
end
