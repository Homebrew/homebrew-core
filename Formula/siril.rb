class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.6.tar.bz2"
  sha256 "255dbffb72bb39b1d9d56ab948b4cad32d1458161b1d997cd84ada21f9a8499f"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "46a778d0aff3f24d838ba4572c8875a7fb6ca1dbb28a0ae4a81e5074ec14d19e" => :catalina
    sha256 "c9968a578ce015c0921cd3c655433d28922f2916cade09945729db3b3e3b9358" => :mojave
    sha256 "8c9f792e64db64f7bff90d815b29e3c99c69188c67694be0ed5ac6064f055306" => :high_sierra
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
