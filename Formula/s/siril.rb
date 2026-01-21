class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.1.tar.bz2"
  sha256 "5547567e4f72318d650f21234cfe109b578d6d0cdea23799dbe8a91f707a5cc9"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "904cf68dba122089fa61aa452d2bc1ed1a098f7da1710d94ec466c7a1696e7ff"
    sha256 arm64_sequoia: "47cb070113063a99c3a376e9473c5a05fc6905b93a728b32c9170cecddbd5c1d"
    sha256 arm64_sonoma:  "d12174612e523f9a6579eaba278d8562c703e6ccb94462972e8d7e93d455a010"
    sha256 sonoma:        "17c6a86aa66a7c8f028e9658baebf1f3a8a5664e5757773cae0150aa8b21120c"
    sha256 arm64_linux:   "f119337c95814c32f5966099d2220845261af7afd02a4410d5417cc5e04797e2"
    sha256 x86_64_linux:  "a3545f938ba6ff96f794250dadd93a1ff24bba0b6d12359dd57b4aeee2581d51"
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
