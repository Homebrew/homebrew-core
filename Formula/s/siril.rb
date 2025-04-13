class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.6.tar.bz2"
  sha256 "312f82e78599f796d163a6d1c90589df1ed920b9ff2bb7ab5b808e43872817fa"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:  "171ce749ea3bc8d30136add12ec9b2fe77e07f86b7fb30f969c4bcbecfa760a1"
    sha256 arm64_ventura: "ee29ef38b0f7f8049c8b2b1e8cdb1e0c428ab08a80286aeffaa4046c3007f878"
    sha256 sonoma:        "77568a6872f7d120b4100e9bfde547849cead2603b1e2e16c6a23abc172a84bb"
    sha256 ventura:       "1983446eda684e05754ba5c5dcd755fd8331b6ed2cefb49cdc2811e53ff4cffc"
    sha256 x86_64_linux:  "54e06821414c9982faec304f5b95db7192f4408de5762cb407ace96e5d363c43"
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
