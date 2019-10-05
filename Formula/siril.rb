class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.11.tar.bz2"
  sha256 "d30e40eed82af9d8e4392c5d888047b1a87a1705514444da3f319845b0652349"
  revision 3
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "3ec281270e986fa3ee19209e1c188379919d55981fb9985f94e7a79b35cfe262" => :catalina
    sha256 "dc6393027ae91470d270f501e0c8dc009bc8e296dd7865952008b26ea332585e" => :mojave
    sha256 "d9fee07b6d7434c5130420f16f918ac4ce0b9bdceb0930bb18a484c5ddf0fa5d" => :high_sierra
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
