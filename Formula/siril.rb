class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.6.tar.bz2"
  sha256 "255dbffb72bb39b1d9d56ab948b4cad32d1458161b1d997cd84ada21f9a8499f"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "3e10bd0e65bf4ff0399380fc5c6b19d1a9495c57df54515e68b72c084ff89e57" => :catalina
    sha256 "6a944291e017a9e547a57e5353cd7d386fef651f57da9abb08efb341e0b74f41" => :mojave
    sha256 "c1c7b7ac925acbcb106eaaa1681eed2c561bf1c911424687b1d5583f6ed31371" => :high_sierra
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
