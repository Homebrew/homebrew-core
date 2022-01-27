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
    sha256 arm64_monterey: "92408ef24365a7646783119eb2ecfdd98126fc868d52ca3cf31fc8c1fb5996ec"
    sha256 arm64_big_sur:  "b3190a3e8af7cb52ab23bbf21e6334cf4860d4ae9e4d9e7791ad8d8d70e352a7"
    sha256 monterey:       "42529cf031920441b336400a3ecfec27aa5d4033a32b8e504f68c00285f8505a"
    sha256 big_sur:        "9c2f5fbcab4a5a0eb3f0a8d25451b806473efdaf3acf4b7ca005d646f5690574"
    sha256 catalina:       "9fd0dd3efa4d7e8848c48d4c554d7854d52746e3d45c5473b0e8ce98002dd3dc"
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
