class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.3.tar.bz2"
  sha256 "f6ca57b668441505010673b153f85fa23efdf41fe74ee7ecb5a4926a572acfa3"
  revision 2
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "15da3809a94bc1c733c56c0291ae90c4475ed0e59e2e84553b51d30430d1040c" => :high_sierra
    sha256 "7dc626da3c06f0aafc1d5a164e6da3d0933aa0c23e686f8f8ad203f205673b50" => :sierra
    sha256 "5d17fea1075b783349ffdec53a855e42bbfec6679fde32823186c964e9dcab12" => :el_capitan
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
