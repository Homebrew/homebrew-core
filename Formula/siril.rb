class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.10.1.tar.bz2"
  sha256 "a0b3debc1efb313a84958fb1819b3a5d0a1395b096db54cce7e3e34a463a5c79"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "8d84d7c672e760216a05caafe20271b09ad1cece7d1507c2bb5c8e2ae1482e89"
    sha256 arm64_big_sur:  "d985fb3e1f27f84dfad04f852e2da82bd7facaa8feffb7d12ecef8577d5c1bdd"
    sha256 big_sur:        "c48c58ac6b19df48df35cdd2b7629c2027b5e85ef33244975abe14a6bcf2aa85"
    sha256 catalina:       "5366c67c6bdfb3b1ac6866d1ddfab61bcfb0baaaa0bb77f79c0b7fbb776b5fb3"
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
