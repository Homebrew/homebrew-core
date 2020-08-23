class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.4.tar.bz2"
  sha256 "80c0fcd750c034608464dfd443685ee51096df8b0b495d1743e6284d22f45f38"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "42ec041e02ee5d09131c256f96f202d325c06878bc142841699d9cf7a98f125b" => :catalina
    sha256 "00e7b66ced0dc8e4ae619713e4ed2cc075061b9137485a2b33a7ab733d3b2d82" => :mojave
    sha256 "21fbaa766a7ddd7d70a549e77a5ee04e1ae2fdcd83d2b6fae21926f01fde15e4" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
