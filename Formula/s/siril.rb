class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.1.tar.bz2"
  sha256 "b1b44e9334df137bea5a73d9a84ebe71072bf622c63020a2a7a5536ecff1cd91"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "af55d2d35973a4272999571a7681bfc408fd8a9d49a6bc480cd975921ae33e7e"
    sha256 arm64_ventura:  "80ee0204dfec028108dfa5e07db4dad38b386f6163bc91b3d192554395f4c1d3"
    sha256 arm64_monterey: "83da42d1ad9e340b620e3e7cec4a8c300c080ecb95111b45643991dbbd7eaa12"
    sha256 sonoma:         "6da10980001fa4d5dec8a66e75d5cc64fb91d9ee49af0df02303ec497cc782a2"
    sha256 ventura:        "12dc528d824afb5764b90cf81d94cc3adf84cb4c503a6da103bca84ef9daec37"
    sha256 monterey:       "aa1c30685c121a499971686a5348256e09b4457e597d39f88af04bd974d13956"
    sha256 x86_64_linux:   "438960f33418d162c04c735ee5f49253f0b235a9b9a3474682a84037b248ab4d"
  end

  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"
  depends_on "wcslib"

  uses_from_macos "perl" => :build

  on_macos do
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
