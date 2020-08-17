class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.4.tar.bz2"
  sha256 "80c0fcd750c034608464dfd443685ee51096df8b0b495d1743e6284d22f45f38"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "67b6fadc0395a67e3f6d9c62e5aa799943c88667fb314ecb7c7bf2fc5cf4df56" => :catalina
    sha256 "e648058025e964763cec9bdac798cf2f22de519509369484e3ef9c3187c5fcca" => :mojave
    sha256 "642afa82a18456cf54339bbb402d25805f88628c64e02f32eb35dbde4f98990f" => :high_sierra
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
