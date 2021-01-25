class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.5.tar.gz"
  sha256 "56b978faaeb8b2896032bd604d03c3501002187eef1ca58ceced40f11a65dc0e"
  license "GPL-2.0-or-later"
  revision 1
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "c07d71cebd01929ae44bb80611d761c10c5f8ae53b2ac8e855d2a77bb9ce2270" => :big_sur
    sha256 "32421c80ed1f4fd835143587ec1d666941aadaefa2ea5facd2bbd2355cc078c4" => :catalina
    sha256 "04964db736a6895edf14f3e0d1cd8dce585c18b56dd123f6376bb2743a1d9953" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg"
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
    assert_match "cycle limit reached", shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
  end
end
