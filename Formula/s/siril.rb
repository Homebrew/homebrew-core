class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.2.tar.bz2"
  sha256 "49b7a59011a30642f4a0d1cd6eae32eace584f425bd709fa8ecab52b5ba98adc"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d470d6dd615945150fdf979b8eaaf8800297965c1a22bc6ce202131f6594a2ca"
    sha256 arm64_ventura:  "fdc10b118f2337c5604cd5e3f5f3ff88251a1f31876926accb37a94b52b4bf13"
    sha256 arm64_monterey: "96160a3db042fefb56f9bb83006eaf9b3d56a8ee28d203ce5c6557b37e89d12c"
    sha256 sonoma:         "273c5af66607c5e34efcda1fb9efb830f9dc9b77e72ee987b4cebc19422c81f7"
    sha256 ventura:        "6df98e81ae0c26da2fac12f96e993b6ca95e345398bce22b00f6322dfedfe484"
    sha256 monterey:       "b13627a0d26ef2fcdca96412ebd8e981bcc2707e3ec3ff8af0ec4c311935ea3d"
    sha256 x86_64_linux:   "5a41c8715587101f80eadae7f66160d7c220a94091813c48345ee76d92744c56"
  end

  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffmpeg@6"
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
