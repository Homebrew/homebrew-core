class Siril < Formula
  desc "Astronomical image (pre-)processing application"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.tar.bz2"
  sha256 "ecb5477937afc02cc89cb07f4a7b99d2d0ab4cc5e715ec536e9be5c92a187170"
  head "https://free-astro.org/svn/siril/"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "adwaita-icon-theme"
  depends_on "openjpeg"
  depends_on "cfitsio"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "gsl"
  depends_on "opencv"
  depends_on "gnuplot" => :optional
  depends_on "gtk-mac-integration"
  depends_on "gcc" # for OpenMP
  needs :cxx11

  def install
    ENV.cxx11 if build.with? "openmp"

    args = ["--prefix=#{prefix}"]
    args << "--enable-openmp"
    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
