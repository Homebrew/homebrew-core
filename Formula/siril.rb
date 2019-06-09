class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.11.tar.bz2"
  sha256 "d30e40eed82af9d8e4392c5d888047b1a87a1705514444da3f319845b0652349"
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "90a76745925dc03b623cd469659f4dc29126d8f830640bcafbf61ca7ea515f0d" => :mojave
    sha256 "a45d0a8022008cffeb832fe57e79403b666cd464c7436d5b02fc61bd5833073e" => :high_sierra
    sha256 "0a5a144f620e2e08919d84e7effe4e54dfbf57d76cdf1c00e6cdd6009119b403" => :sierra
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
