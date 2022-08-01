class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.3.tar.bz2"
  sha256 "2fefa7b7e1378f4ba277818c92ec7c4fca1fdcaa6df95bb65aed0163750be2c6"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 arm64_monterey: "6e2a517c7c7c697440ef5ca850bed738a117f88e55c4962766c9e7dca72d7d41"
    sha256 arm64_big_sur:  "a6ebd53726bc9d9d24ea3ca857507801ad45e1d99ff3c773bf8ac38ec459730b"
    sha256 monterey:       "cf1b0437f4c1abf99267ec82393cece1d3f44e8e5815de1c8d38b634adb3e802"
    sha256 big_sur:        "1c471f84f0e3635888a951d9addae170d61c1d3b54d15a26ca9f0f2c2450b1d3"
    sha256 catalina:       "ebc5dc9a3e151c417833782f22c48e4af5302ac927e004c99c8e8ca6e5ef0916"
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
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"
    ENV.append_to_cflags "-Xpreprocessor -fopenmp -lomp" if OS.mac?

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
