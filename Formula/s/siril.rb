class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.5.tar.bz2"
  sha256 "698be7f689cffa0d657261f67990e7de7d02d527f999cedfa48af523dcd74270"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:  "08df52ac9311764bf8d1ba78516257a38fe38e901dc9e82d6c564c555b4de21f"
    sha256 arm64_ventura: "e79464d9a21088a5a3d710e5cc4d3c17133a1cf0bb647acdf0e477a192cbcf7a"
    sha256 sonoma:        "c32de5bf98b8717c4f3d7f4082add447c8e4968b07ce4abbb598864592a01ab3"
    sha256 ventura:       "7824bbc875a402b40458457b5efa42e6231faff01b1fddb2fde582747ef9a4dd"
    sha256 x86_64_linux:  "204e715df169dce13714831ab68f116a01ad3b7f90706a9c45dc712b5bf75fac"
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
