class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.6.tar.bz2"
  sha256 "255dbffb72bb39b1d9d56ab948b4cad32d1458161b1d997cd84ada21f9a8499f"
  license "GPL-3.0-or-later"
  revision 5
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "0d72128b05ae3cf96075c4db6c37318d1b328fcca5fc753067f298ecf02cab0c" => :big_sur
    sha256 "99d386ba07d14997d04501e130f046eee5d25653f16f7828ed16fae08cec3eba" => :catalina
    sha256 "0c3d0e33e5d0cfdca10613811884b754b7dfc632d767eafd90fcb5e3486fb257" => :mojave
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
