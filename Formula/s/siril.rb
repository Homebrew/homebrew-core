class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.3.tar.bz2"
  sha256 "8ac660542d2bec5d608eaf9bf25a25e6ba574b58b5410bdb6ad401e1f86fa756"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f4049c40c420b8174844ba34b785415e5018116244e4b28ca558d2864c7674c5"
    sha256 arm64_ventura:  "4f5bc9ae544f1afa038e851e6f166b9d4c1e614d5234a901a370269670746842"
    sha256 arm64_monterey: "92a0d0e303aaad93236f7b24a7e6d2cdca3b8599632314edafed042349530eee"
    sha256 sonoma:         "ccdbec9841ca4ea9288451aaee4db372f83b5ecb2545915c43560002122e290c"
    sha256 ventura:        "fd680dfe41bf64caabcad453873e48ea04dca6ce0b2d92dfc3a2e9db6a6ac854"
    sha256 monterey:       "318344d5a3a07f6d6ac4deaaa89f5bb5dd4d3058cd02890c4b1a03ecb362bddd"
    sha256 x86_64_linux:   "e059dbcf1530ca4e6981213c00604acea83879e071cc5a24272b60174347ab3f"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
