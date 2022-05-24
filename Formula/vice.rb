class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.6.1.tar.gz"
  sha256 "20df84c851aaf2f5000510927f6d31b32f269916d351465c366dc0afc9dc150c"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "33fb1aad075c3b196121b6fc2cc204e28fc926b72481858e47e104e812f3ee50"
    sha256 arm64_big_sur:  "44378ed1786c48a0ce150e9c246829a59166ff8c2548a924f27d5ff2f4957500"
    sha256 monterey:       "642e255aa5c7e4cb48e8773196dd94925e81d11bc5b538f02946af1c70397298"
    sha256 big_sur:        "270cba1e6c87ed97b7cafc142f4610661610a874b2ddb7ba1b805472b004242a"
    sha256 catalina:       "05c3fbd9b2972453bf7d2688ef666efbbd7b9bd5b4fb37b294d3b6c0e45432cb"
    sha256 x86_64_linux:   "29768ca0c24d34dbe29995cca12aec6b2e91f9b2f44252828a62ad1b53e2fa8c"
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
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"

  uses_from_macos "flex" => :build

  def install
    configure_flags = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-arch
      --disable-pdf-docs
      --enable-native-gtk3ui
      --enable-midi
      --enable-lame
      --enable-external-ffmpeg
      --enable-ethernet
      --enable-cpuhistory
      --with-flac
      --with-vorbis
      --with-gif
      --with-jpeg
      --with-png
    ]

    system "./autogen.sh"
    system "./configure", *configure_flags
    system "make", "install"
  end

  test do
    assert_match "Initializing.", shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
  end
end
