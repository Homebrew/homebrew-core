class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.4.tar.bz2"
  sha256 "b1682f2129d2e06b034445ed225766a06e38cfaa7451b92d606a3ee36eb077a4"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "df29b26fb44ebe46e97597e78f519eec6b67e27b77cd529a8eebf7ff1b6ba46a"
    sha256 arm64_sequoia: "27bff4780bffec5e5a882d19abd7487e60bbe398539fdb37950bf3f14f8a5125"
    sha256 arm64_sonoma:  "90b34fc6d8a90e271f898132bcfbf37912e08aa8f7292c0cedbb8167d72f3253"
    sha256 sonoma:        "ec619eedca0e1d9b0954a1a1f476bf67627f1592eca5b19181fde4d0a71ae014"
    sha256 arm64_linux:   "5b83a5b7d3c088acfd9836a5cd9175025155ebaf48646db3484f0b324f421c80"
    sha256 x86_64_linux:  "1f700107507468b1d1daf44cc2287a96c919dcdeaa29b233a79b738cc4afd8ca"
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
