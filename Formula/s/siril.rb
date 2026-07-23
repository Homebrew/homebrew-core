class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.4.tar.bz2"
  sha256 "b1682f2129d2e06b034445ed225766a06e38cfaa7451b92d606a3ee36eb077a4"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b2d7456492b41a400abb841ce2f14b77d6c588fcafaa1fa85abd32ab35fa9192"
    sha256 arm64_sequoia: "b65e29d9183715f8dde2e7ce68640df3dd7fb54a640ecbe8703cca8857f5e553"
    sha256 arm64_sonoma:  "596e0a93cfc58c5ec447d3782047d60a49f8644974768994c58c20aafb5e4ba5"
    sha256 sonoma:        "b43082c7f8eb443e5152a2778a062915a2ad05fdd5af43223d0ecf4206f89e70"
    sha256 arm64_linux:   "c820c2a9966099e8df468dbc2bacee905a937e8670e440431b02fe820c473bf2"
    sha256 x86_64_linux:  "98117ffd8561de7a091eb1a39b073190aa54e201c2271be82ebbeebf8e16511d"
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

  # Build against opencv 5.
  patch do
    url "https://gitlab.com/free-astro/siril/-/commit/743956900c65129ab12421951781c12b94c6e996.diff"
    sha256 "c07b0e62efea0c9622808992bbee77a9e707fb5aaeebf4cd44d9c9a6e680a7c0"
    type :backport
    resolves "https://gitlab.com/free-astro/siril/-/merge_requests/1073"
  end

  deny_network_access!

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
