class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.4.tar.bz2"
  sha256 "11aa4e491e42f606301d214ffec35741ac6522b5a94feab04fb701e829fd5aee"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "2adf77bb80332c5e4f388bf94ce699b5831e6c17877a312195314a87d07e46ee"
    sha256 arm64_big_sur:  "247b5fbfd58643fba2a2b0e8ef134938e839eb012078109e01e471525bda0257"
    sha256 monterey:       "08b19160e6f93bb017906dfc0fece16b539b8d7368b3245f37864f4757bb4be4"
    sha256 big_sur:        "d3adf4ef6a302d0cf9a9048ca9481fdc0cb2432b29efbf11d57e62711ce83285"
    sha256 catalina:       "90b154dd0892855d1e49199e49800cc4486348f225608d122e342d9603fef8e5"
    sha256 x86_64_linux:   "cfec1221e14be7e9cb268f4e8459f1084ff49e81d18a1e6172338e8c58a321c5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
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
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"
    ENV.append_to_cflags "-Xpreprocessor -fopenmp -lomp" if OS.mac?

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"siril", "-v"
  end
end
