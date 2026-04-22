class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.2.tar.bz2"
  sha256 "451915627ae461ef992ac0f83bd3ff1db5102d72ca379eee55b9be4f12b1162b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c610d29be00975c40225d0e59e35748a69d7053271e5d88090c89e7955efc96f"
    sha256 arm64_sequoia: "70368f0900d40131375814487770f46d696e34368fc0ce7c41843faa37e5fef8"
    sha256 arm64_sonoma:  "389d60f93d3e161397a8a9cb678e0789d26a845bd508fe5ff27c2c205e063198"
    sha256 sonoma:        "91e3e3258787d9e1db9e8e81bdc9cc95af82fa27289f3c05c0b72bf06c090038"
    sha256 arm64_linux:   "b1d409fdc38a442e6e524b2994cf6178df93af558537e0703c0df097e8c7bdc4"
    sha256 x86_64_linux:  "85c570a3b5f837e3997bd02dc07cb988effca18b8a832e683e98ad5b2973c2ca"
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
