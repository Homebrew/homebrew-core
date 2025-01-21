class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.5.tar.bz2"
  sha256 "698be7f689cffa0d657261f67990e7de7d02d527f999cedfa48af523dcd74270"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:  "ad0729c7f9755a27ae6a8f0dc8b7b68bf40c27b5d8e6457a7140d7af4785a570"
    sha256 arm64_ventura: "fdd5fbfaa1f25f92bab18c2ea361d4bf3e41f9e618cac24e24deac008ddc67c0"
    sha256 sonoma:        "ed8b020bbcadd8fbcc69804fa040eb0fa457ee1321439f6604c0c94d87de2c5e"
    sha256 ventura:       "9ae2060d2b860a7f91fcf0bd6df3105cfeb1c93fb478edb25971b39e251017f7"
    sha256 x86_64_linux:  "ed47518cedcc6957827e50359c59f4cfd6bf1f1807fbb52daf79a01144d3123a"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
