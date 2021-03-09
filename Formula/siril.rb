class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.8.1.tar.bz2"
  sha256 "45b73ee8d1e1bd7ff184478f90da59c729ca1bd5285fb2f7ac0237c6b5cdbdb2"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 big_sur:  "5e27c3ab3740980331edca631549372c91388342d9e94ee40dbfd6ec25ede24c"
    sha256 catalina: "fe4bb5bff2cf48f9bdd62abe930cf2fde12073bb23cd996f773c02d105cf8376"
    sha256 mojave:   "44132a8e1947801f0a6f1cf7d1ed6ea1e149cf657a49bb931ab66bcc29d9f14b"
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
  depends_on "gtk-mac-integration"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  def install
    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
