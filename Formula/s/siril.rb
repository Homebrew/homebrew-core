class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://free-astro.org/download/siril-1.4.5.tar.bz2"
    sha256 "ed30edc3535d6f8fde2cf84f23039db7c87380f16df740936bdc75362fa50a6d"

    depends_on "gtk+3"
    depends_on "gtksourceview4"
  end

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "8a9757701dbddc9620c0523011db3cae33093166a6622b79c516adf4cee4e03f"
    sha256 arm64_tahoe:       "428994d960a776743c14d6b32509947cc9972d2e282dba264f14cd0b62d5d608"
    sha256 arm64_sequoia:     "fec7fceac9e45cf5a53083d8013d148a3d5791eb6fd6c62e74134c9620c4def8"
    sha256 arm64_linux:       "33dd2268f368cf6258f0f5251907ad9fd49409187c9d6dda1e8365ba6c61dfdb"
    sha256 x86_64_linux:      "bba9f3a79d668e73b5459da7e88ac6fb8e0bd7cc291e764844bd22ea11e41b26"
  end

  head do
    url "https://gitlab.com/free-astro/siril.git", branch: "master"

    depends_on "gtk4"
    depends_on "gtksourceview5"
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
  depends_on "gsl"
  depends_on "healpix"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libgit2"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "little-cms2"
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

  deny_network_access!

  def install
    # OpenCV 5.1.0 removed `Mat_` comma initializers, so build these vectors from `Matx` instead
    inreplace "src/opencv/opencv.cpp", /\(Mat_<double>\(3,1\) << ([^()]+?)\)/, "Mat(Matx31d(\\1))"

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
