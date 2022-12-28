class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.7.1.tar.gz"
  sha256 "7e3811e6024db0698bfbc321bb324572446b8853d01b4073f09865957b0cab98"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "2d2a5091508600895e131976680b7fa7271137a8d0c38e058bb41487da0e095c"
    sha256 arm64_monterey: "94f93f6a27f46d2b23995d712570f80548875af3bbf3afe4fcda14c24d93a4c6"
    sha256 arm64_big_sur:  "735adf7db037698c482dbbe905815a09cef67eb1a4dc1bfd5f6bf171ff721be2"
    sha256 ventura:        "a6f66b5f468e818b1f4609d71459a1ee40336f83959d4ffd2a1ef246738eee71"
    sha256 monterey:       "3441d023a175cd3c095691736f233e592b53aa24cbdb9e5c7ee69511fb13ac73"
    sha256 big_sur:        "10419ceec6eb25e28d3e61e166890b73ed98d4daf36dd5f6675a59f777e8a542"
    sha256 x86_64_linux:   "13a587182c1b95a97d2801804aac8df10c36953dcf2601c755d232fb1a47e0a3"
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
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
    assert_match "Initializing chip model", output
  end
end
