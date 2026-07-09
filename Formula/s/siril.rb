class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.4.tar.bz2"
  sha256 "b1682f2129d2e06b034445ed225766a06e38cfaa7451b92d606a3ee36eb077a4"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c977a4662ddb82a532c39f7e85a0b45e80532ef1ea8ca4c87a1d6be4d0fe6ce9"
    sha256 arm64_sequoia: "1496181c18b5d3724c2cdc71310740be44158b9cc9f13d142da43185328f859d"
    sha256 arm64_sonoma:  "f6b8ab2471ae8e4d32fb3940af44eb4486464c53f9ead3cd6e5bdca7b9b3017a"
    sha256 sonoma:        "9d2bb6029801c4a29a9fc11eff9375b372b5be5b2020e033bb22a64e639ab8c6"
    sha256 arm64_linux:   "3d0d5dbc4a4fe341ea62141c208419f630871008e545c81745fd39331cfee0a6"
    sha256 x86_64_linux:  "ac47a0d321e1a53379c6eda5014da49d69bfb62ca6b84c7c876c7a729743a01b"
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
