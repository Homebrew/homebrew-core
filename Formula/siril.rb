class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "cd93b7044de56214d131a00cd9990e5c3acb4f3f2c1eb6d9c957f4cdbdf9e4f3"
    sha256 arm64_monterey: "14487c6749ab1206916d60a18edc7b23c1b9204b457e6506729dd52a6d6d286b"
    sha256 arm64_big_sur:  "336e2300d8fcae3bc023baf331f62d6a7cc8e215c6e089d2c9f5c1de0e1be0fa"
    sha256 ventura:        "ebb53c1dac1b57cc67b038afa629d17ceea962602aac551c549ae74d5e439785"
    sha256 monterey:       "422072d115df5a3cd3d434269530e27de88b1e027e96081b0c1a69b3f2e34bdc"
    sha256 big_sur:        "83fdedd785718177b778a5c1ffb40389481eeb587f0a39c680256173bb6aac1e"
    sha256 x86_64_linux:   "1464bf2d8ba64c3d259f179a7c1770ca8582a44183069c07f6482af92f9c111d"
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
  depends_on "wcslib"

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
