class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.1.tar.bz2"
  sha256 "5547567e4f72318d650f21234cfe109b578d6d0cdea23799dbe8a91f707a5cc9"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "84d1bfdc4ef9040260ec4c1b2cb71b50e9eade7eb6fb1af050f8d82c97baf000"
    sha256 arm64_sequoia: "7637cc01dfa0275ec6b88b31b44f52f8114799f265c9010517b4ca327f604db8"
    sha256 arm64_sonoma:  "0f099d1c340d530c942c75deb4403b9fddd0b1e2dcf1571909f8aabd68cc56b1"
    sha256 sonoma:        "d15d9cd77cf511d41746438bd8262caec8a9b77145007ee5961e678049fdff5e"
    sha256 arm64_linux:   "e723789c6d5338ab3bec9924c83d598c6a1e6513aa44cbe64381a7ab099d8a70"
    sha256 x86_64_linux:  "be293d205a331883ff439ee38a773f6a3dddfb102daf006b465abf9aa8d32e7b"
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
