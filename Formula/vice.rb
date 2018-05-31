class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.2.tar.gz"
  sha256 "28d99f5e110720c97ef16d8dd4219cf9a67661d58819835d19378143697ba523"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cfc6a84e02744b85867aeeef591fb185de4a8560a1fbbc7dc50a53a8d0393b59" => :high_sierra
    sha256 "39bfe0b566c65cb01ce976dbb5be3fbf46b4486bc9678f8c5b288fd2d8bb265d" => :sierra
    sha256 "34ff96ca0fdc51f4a873970d00bcab347c3483fad7ee1a670e1c49182690cd2e" => :el_capitan
    sha256 "ab4044f958907bd7d756575fc97e0e42ffc24307c621176da0d0522feadb22f4" => :yosemite
  end

  head do
    url "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "yasm" => :build
  depends_on "xa" => :build
  depends_on "ffmpeg@2.8"
  depends_on "flac"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "xz"
  depends_on "sdl2"
  depends_on "gtk+3" => :optional

  def install
    ENV.prepend_path "PATH", "/usr/local/opt/ffmpeg@2.8/bin"
    ENV.prepend_path "PKG_CONFIG_PATH", "/usr/local/opt/ffmpeg@2.8/lib/pkgconfig"

    if build.with?("gtk+3") && !build.head?
      odie "Can only build gtk3ui with '--HEAD'."
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-bundle
      --enable-external-ffmpeg
      --disable-arch
    ]

    args << "--enable-debug" if build.with? "debug"
    args << "--enable-sdlui2" if build.without? "gtk+3"
    args << "--enable-native-gtk3ui" if build.with? "gtk+3"

    # Hardcode this so people do not have to set DYLD_LIBRARY_PATH
    inreplace "src/arch/sdl/archdep_unix.h", "\"lib\" #name \".\" #version \".dylib\"", "\"/usr/local/opt/ffmpeg@2.8/lib/lib\" #name \".\" #version \".dylib\"" if build.without? "gtk+3"
    inreplace "src/arch/gtk3/archdep_unix.h", "\"lib\" #name \".\" #version \".dylib\"", "\"/usr/local/opt/ffmpeg@2.8/lib/lib\" #name \".\" #version \".dylib\"" if build.with? "gtk+3"

    # Skip the X11 font stuff
    inreplace "data/fonts/Makefile.am", %r{^@SDL_COMPILE_FALSE@}, "@SDL_COMPILE_FALSE@@UNIX_MACOSX_COMPILE_FALSE@" if build.with? "gtk+3"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    App bundles are no longer built for each emulator. The binaries are
    available in #{HOMEBREW_PREFIX}/bin directly instead.
  EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end
