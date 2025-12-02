class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.6.tar.bz2"
  sha256 "312f82e78599f796d163a6d1c90589df1ed920b9ff2bb7ab5b808e43872817fa"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "08563c86ad8444f9f5bb08aa418380342448b6ff62dc37f62f2dae5ae2ca2d8f"
    sha256 arm64_sequoia: "056cc668684cab712e919c26b6817f59069fc10c607f88ee7d76e0725e19604e"
    sha256 arm64_sonoma:  "e56ba213d399b3e1ac714a78c9d710f0cd49ea9245dd3d25f667f88db5c0dad5"
    sha256 arm64_ventura: "a71c1f6a8798b1bdaf26d88d0f9e8bde62603c933859e9e8f34d5c69e1b7a452"
    sha256 sonoma:        "852c1a015a8472d91394191923c377832c02b5cfb30f3695d0979a3702b143b1"
    sha256 ventura:       "10d755c99a9eec1368ce76aac5905305dadf1666634c5c66e20b5d3676fdab9b"
    sha256 arm64_linux:   "9bcaacd18e1113c6ca812d872246ac81e398e1a6ce8c3e2490278b005feb7451"
    sha256 x86_64_linux:  "d96875e709864a5af01a2af6605ecccb944c41e567d8a9c4b7e54cc7858399b0"
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
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "netpbm"
  depends_on "opencv"
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
