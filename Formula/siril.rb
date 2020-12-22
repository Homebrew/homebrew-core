class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.6.tar.bz2"
  sha256 "255dbffb72bb39b1d9d56ab948b4cad32d1458161b1d997cd84ada21f9a8499f"
  license "GPL-3.0-or-later"
  revision 4
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "2b77ee77a98d84b1b431d8dc0b70c4f3a8444339965f2a5a49b985877b074097" => :big_sur
    sha256 "0cb6f876f01593f9f426968ee7e28253cb7c6f8e5631cc98d98b38bb66b84063" => :catalina
    sha256 "91fb48816b28441037c6a37c8b4696ad3d0e3665c1f3d1528a5ed1600e3ca4fb" => :mojave
    sha256 "a9fe6c183f95de6b735434a45a516567380792ec14047f36bf6d2c5a8912c170" => :high_sierra
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
