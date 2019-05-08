class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.10.tar.bz2"
  sha256 "caf9800a442bbe3991e820ffc66f41b453c6866f510e2934d236788c78f5be29"
  revision 2
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "8cf5fbff67b489598115f131d8085d7721a22c82850fdf942bf15e5dafccc34b" => :mojave
    sha256 "af0df6135e247a89506a25ba79532e2a9f478de23243ac66ec44c212372fa45a" => :high_sierra
    sha256 "9d657c61fa37492720051e64e11e857b5edab6e79dc5b85427b9dd191005f6d8" => :sierra
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
