class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.12.tar.bz2"
  sha256 "9fb7f8a10630ea028137e8f213727519ae9916ea1d88cd8d0cc87f336d8d53b1"
  revision 1
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "e22e39d998cf813effc6bace7720826f77e9e2fa5012dddcf3280c5036f738f2" => :catalina
    sha256 "190fd5ea15de9e7cf72b2925faa4aab6e27780685a1f858712f87e8606590b8c" => :mojave
    sha256 "a49b471b0659d392cd265351824314caa69d027ebfa4a25011186d06e465ae23" => :high_sierra
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
