class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.4.tar.bz2"
  sha256 "6d9391558b4289615ad0567e953ef645df9a00965c6c6fbc723ad25f3ac0925a"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "18d857fa2251085c51fabbe80fd0afcf4b04da7ac700f00063fbd49cd8fdf34b"
    sha256 arm64_ventura:  "827f6ac0b787fcad63b1cbaaaf49e3cc2e75e7ada8259651f9581ca352584f77"
    sha256 arm64_monterey: "84c02fc306787657281c512b983e6c91057f41738bee0c8158b02ac067c4d0fc"
    sha256 sonoma:         "e271167f4688b1020d1e1dd907875b11f23e61c7ad76cb934a1bc3d0ccfc0c2a"
    sha256 ventura:        "f1bfa543e11626e6e4736e87697f82210fa59f7ae7308e374db8c4828a0aa80b"
    sha256 monterey:       "f73f021d14bd9eef882abe226d7cfc5f5a1000231735ffa41fe2a6f71e472136"
    sha256 x86_64_linux:   "756fc0a1c9f6344351bece2c2161dd0ce52c5c1839fbb7322ee571172d7c98c3"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffmpeg"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "wcslib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    args = %w[
      --force-fallback-for=kplot
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"
  end

  test do
    system bin/"siril", "-v"
  end
end
