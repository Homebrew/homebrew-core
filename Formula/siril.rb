class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.3.tar.bz2"
  sha256 "2fefa7b7e1378f4ba277818c92ec7c4fca1fdcaa6df95bb65aed0163750be2c6"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "39d6afd06af9b20a1f5d6c8bbff1a900f260574a40c5a33d72d2c9d3f45ce59f"
    sha256 arm64_big_sur:  "19ce4682737ee351a534fe412a98b1b78f979915744f7ff852aa8cf03cebb334"
    sha256 monterey:       "f879bcd08809856c1a4a80bb3cf5d60712b6b31336963dbadaff78ff0ffa63f8"
    sha256 big_sur:        "c03f0edbdec099acee0f9809fbda95d74ac53067ab95175e95dd772b86202bd3"
    sha256 catalina:       "40393dbccdb450a99e43b75626285c185ff79e5da895024e49b6bba0494b4beb"
    sha256 x86_64_linux:   "bf2bc36f50948a181be852ea41b9643efe5429c9fcfcb9a869c3a74dd1ca7c99"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"
    ENV.append_to_cflags "-Xpreprocessor -fopenmp -lomp" if OS.mac?

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
