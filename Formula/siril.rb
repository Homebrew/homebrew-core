class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.8.1.tar.bz2"
  sha256 "45b73ee8d1e1bd7ff184478f90da59c729ca1bd5285fb2f7ac0237c6b5cdbdb2"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "5b91d3cdfb919a7aa31d421baff057b6065301cc931726b33db1b0a8c38eabd6"
    sha256 big_sur:       "9269d262d5b6bcb897c7dd254f6044a6afe2f304ce48fa01f2e054858fb4700b"
    sha256 catalina:      "e984a5b1f8becace8ad0e3c48b31238c9146d9af741e1cdd040ec04b4dd2fe3b"
    sha256 mojave:        "cab28144f4bfa18c0871aebff227d80912be07794ddab339eab252b554884e4d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
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
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  # Fix build with glib 2.68.
  # Remove with the next release.
  patch do
    url "https://gitlab.com/free-astro/siril/-/commit/d319fceca5b00f156e1c5e3512d3ac1f41beb16a.diff"
    sha256 "dd3593a8158bf661382995859665546d9fbf8b29822ad100e6a06c44f57d6013"
  end

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
