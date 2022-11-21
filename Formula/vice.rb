class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.6.1.tar.gz"
  sha256 "20df84c851aaf2f5000510927f6d31b32f269916d351465c366dc0afc9dc150c"
  license "GPL-2.0-or-later"
  revision 2
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "d62ad32d65d8cd540122d6ef6f822fdf57c018956debf7f8bcfe9015a26677f1"
    sha256 arm64_monterey: "cee4c0f296da3732d391c5f3590930d98174ec00fc6ccf94c48b89c7021c0a43"
    sha256 arm64_big_sur:  "74af37fdd526129db172903f6ab915ece592a53e18c8fe08ef1b1e286e4fe94b"
    sha256 ventura:        "e469d5be05528ab44391141f09d6eca93f827692003763e51a3894ee4e7c667f"
    sha256 monterey:       "f1057d64cdaa568258a37f21e5de39ed2b2670d0288d4236cf6a9629cf6c2e0a"
    sha256 big_sur:        "496ee709a8fbe0db29d951196a057990cbfd430f391ee6d1e3c6f77b1620c2ea"
    sha256 catalina:       "6d9c828065ce78743ca1b6c03715e6d53f2257431c81e129f9bed65537a64fab"
    sha256 x86_64_linux:   "dffa88b6a794cdeb51087b1c2ddfa6aafbf132189f88fa48e2dfed8783342acc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg@4"
  depends_on "flac"
  depends_on "giflib"
  depends_on "glew"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-arch",
                          "--disable-pdf-docs",
                          "--enable-native-gtk3ui",
                          "--enable-midi",
                          "--enable-lame",
                          "--enable-external-ffmpeg",
                          "--enable-ethernet",
                          "--enable-cpuhistory",
                          "--with-flac",
                          "--with-vorbis",
                          "--with-gif",
                          "--with-jpeg",
                          "--with-png"
    system "make", "install"
  end

  test do
    assert_match "Initializing.", shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
  end
end
