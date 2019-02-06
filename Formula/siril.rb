class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.10.tar.bz2"
  sha256 "caf9800a442bbe3991e820ffc66f41b453c6866f510e2934d236788c78f5be29"
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "5275322d6d5db51234302740de930e5b9780f247c42f5fd8b63ca2caa4158e37" => :mojave
    sha256 "6185ae22ec5a93a0a41cab9231f0056abc7f636db05796fe7d9bbb8593788243" => :high_sierra
    sha256 "c559b90529e06f6373744b300d19b0685d5d4b629bdacfc0a322bc9bc0f27e51" => :sierra
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
