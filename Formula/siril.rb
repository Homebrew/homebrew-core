class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.11.tar.bz2"
  sha256 "d30e40eed82af9d8e4392c5d888047b1a87a1705514444da3f319845b0652349"
  revision 3
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "ef3edf7aed84367a69978aee49a67e92a39265a3e580e187f2f31d20abc0941d" => :mojave
    sha256 "a65184ed56ff18010047b203712747b69e3c2a55e93234f9bc3f528c5edfc212" => :high_sierra
    sha256 "9377b176b2dcc4bb9dda274951a9719301b0aba039ba3bf3bafc25cb688e42f7" => :sierra
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
