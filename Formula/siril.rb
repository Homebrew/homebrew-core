class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.3.tar.bz2"
  sha256 "f6ca57b668441505010673b153f85fa23efdf41fe74ee7ecb5a4926a572acfa3"
  revision 1
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "d4f6772fa34f9cce8bcde06208473cdf9b6104a1e41598632647e5107d915cf8" => :high_sierra
    sha256 "c269d8eec18db7317dab26a22fc83e11c594d6d0adc1311be579e4e2e6d092f3" => :sierra
    sha256 "16d222ffcf03b5a9468e77d8541507590efaae2f2e2a02fd86d054657c4b158c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk-mac-integration"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  fails_with :clang # no OpenMP support

  needs :cxx11

  def install
    ENV.cxx11

    system "./autogen.sh", "--prefix=#{prefix}", "--enable-openmp"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
