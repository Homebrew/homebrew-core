class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.5.tar.gz"
  sha256 "56b978faaeb8b2896032bd604d03c3501002187eef1ca58ceced40f11a65dc0e"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "1a0bc0f49e3f16b32f678547fef6acf1aad720e20e033651f4516b280c86a6d6" => :big_sur
    sha256 "b65fbef8066263ccd42679a2b9ed9f3d438ff75a5d8c097dcf04ffb5fa1b1e43" => :catalina
    sha256 "65380e5bdb80143cfbd668fe45c385b7715faa6baa8f109707003be3fb410efb" => :mojave
    sha256 "d2532e0ccc1a84a9896a611c9ac7eac15342f7ebbaedba7c0b29f36c178a0c27" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "dos2unix"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "gtk+3" if build.head?
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libnet"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "sdl2" unless build.head?
  depends_on "sdl2_image"
  depends_on "xz"

  def install
    configure_flags = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-arch
      --disable-pdf-docs
      --enable-external-ffmpeg
    ]

    configure_flags << if build.head?
      "--enable-native-gtk3ui"
    else
      "--enable-sdlui2"
    end

    system "./autogen.sh"
    system "./configure", *configure_flags
    system "make", "install"
  end

  def caveats
    <<~EOS
      App bundles are no longer built for each emulator. The binaries are
      available in #{HOMEBREW_PREFIX}/bin directly instead.
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end
