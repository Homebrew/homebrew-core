class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.10.1.tar.bz2"
  sha256 "a0b3debc1efb313a84958fb1819b3a5d0a1395b096db54cce7e3e34a463a5c79"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "3452a13a60d554326f38b94cadc30e40825505be16b13cb29ac702c04f7a96d8"
    sha256 arm64_big_sur:  "e4f44608df244db1cf93aaae0552a78939161e3e56bd419a8d295c8ead458949"
    sha256 monterey:       "cbaedd63971bde183f4bc86ad48ccce009921ca2b4ef4253cf457701a5a4d8ce"
    sha256 big_sur:        "39e80b1af4a4d24885c88a1df965f745a4a321bdca33e2c78d4f7ecbe76a9396"
    sha256 catalina:       "56dcd8c9268959c755422b9f1425d2bd46ad698edd65df04f3acd6585f247700"
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

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
