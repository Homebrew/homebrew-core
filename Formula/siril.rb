class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.12.tar.bz2"
  sha256 "9fb7f8a10630ea028137e8f213727519ae9916ea1d88cd8d0cc87f336d8d53b1"
  revision 3
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "353c90b73b9e1c8179312112b8595671d13aa849e4adaa90b37c6d8d899770d0" => :catalina
    sha256 "4401db28ce4f8dbe5b43b58e5fb503d48358d80c6e400433a6db20ac2f2d7416" => :mojave
    sha256 "076e1a58038f3fa3b207e21385a4799d65018c0da7fa05db81c3882ce95224e0" => :high_sierra
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
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
