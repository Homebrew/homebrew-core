class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.10.1.tar.bz2"
  sha256 "a0b3debc1efb313a84958fb1819b3a5d0a1395b096db54cce7e3e34a463a5c79"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "9c4d6ad7245679522b0814c5eed4a3cb513372f176187889242391e06e97042a"
    sha256 arm64_big_sur:  "632c6921a69d53bcde16aeb223d8e5f4d986397d06ad75e22328d51ba3096fae"
    sha256 big_sur:        "fd3867ce36af425a70aaa5e096123e44be11e2c62d383d86c7e0f2867926ef19"
    sha256 catalina:       "f5584b0bdbe0574521a96ac7b382e41216e0f760188f38d09c2bacb9879dcb48"
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
  depends_on "gtk-mac-integration"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
