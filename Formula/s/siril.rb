class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.3.tar.bz2"
  sha256 "d8afb8480fd9de6d01760e4bf4aa187e799f7bb25ac9226ebe996a1c7cd3491a"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1c3225c848ed0a3a6996899dca540a3b37cba50dbb5add418bbb1f2fdb265103"
    sha256 arm64_sequoia: "55053b41bc2186cc60bea129d6133b6c383f91d3dace8995106a5da4e82bd654"
    sha256 arm64_sonoma:  "0914c82c8043bc66393745fd705a9c2c049a656b9fbbc183d41ad1705a060f92"
    sha256 sonoma:        "fccc1764df942299371673a9f2309e1d6f936a8209063e889463a804c8e93e27"
    sha256 arm64_linux:   "6603998dcb5ca7679a7893940c6a7fb23ea6939291c1729f8eacb07643b6ea1a"
    sha256 x86_64_linux:  "59c409e107266e4af5b0e4ace2c2c7c74d88d73eeeb43c72327ea34d8a7fa7e3"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
  depends_on "gtksourceview4"
  depends_on "healpix"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-glib"
  depends_on "libgit2"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "pango"
  depends_on "wcslib"
  depends_on "yyjson"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "libomp"
  end

  def install
    args = %w[
      --force-fallback-for=kplot
      -DlibXISF=false
      -Dcriterion=false
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"
  end

  test do
    system bin/"siril", "-v"
  end
end
