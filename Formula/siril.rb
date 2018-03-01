class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.3.tar.bz2"
  sha256 "f6ca57b668441505010673b153f85fa23efdf41fe74ee7ecb5a4926a572acfa3"
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "31621cf7b947d6e0142179b43f343e2a35d7bbc4eb3b958eb1189a561539e1b9" => :high_sierra
    sha256 "c9dff3079d48f2aa4dfa84b2db3ef1fb3a3233a092bd80b5948bddc24de2729e" => :sierra
    sha256 "4ae351a5cc369b17d9f2382392e7a8458a1ca5ec9fe7d81ae970bc7701eeffae" => :el_capitan
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
