class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.8.tar.gz"
  sha256 "1d7dc4d0f2bbcc2a871bb954ff4a5df63048dea9c16f5f1e9bc8260fa41a1004"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "27ee6052b18ef33d3506287af4026da0058bafcbba1c4f2c42653b2ebff55275"
    sha256 arm64_sonoma:   "163a28f5f228bda4494e240c888a18f33d9fc92a45999d65431c91d196bb4279"
    sha256 arm64_ventura:  "649950d292263d4acd2003e830bcc8d5f53d570f71ae9b9c1d15b0ee17e95ed1"
    sha256 arm64_monterey: "f1ae86341d60851431b2500e01047610456dee0d4f5173ad0e44b921dd143859"
    sha256 sonoma:         "1399cd7f168537868340913dc9daf51dc45f9f936ed17b19e7552ef05c165e6e"
    sha256 ventura:        "11775c1d4596bde29837c632e6bcb6f0746d93461bedded7d25f81f2e52aadfa"
    sha256 monterey:       "7e31e99728c4aa15570848d3da0839f8b3af34c654dc2bbb24a864fb49a0a0c3"
    sha256 x86_64_linux:   "56cbe974416e6d4e257df439151d9fa8a4594e3a305df4aff2a42c10239472ef"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
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
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
    assert_match "Initializing chip model", output
  end
end
