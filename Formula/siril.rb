class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.2.tar.bz2"
  sha256 "4973bd7ad6d3cb7ad279ef27bb5c79f37ca1f914c7b6ad8fe689e1d59189f2db"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a953ea0ed1b5ce1279d6ba37cf983252f5ffc9dd9b9df0840ba435bc20bbcb89"
    sha256 arm64_big_sur:  "bae5aed8f49b49db1355e75cba40726a818dbd018bf739821f1409f2febe90a5"
    sha256 monterey:       "ab1e16ed4e072ad269bc9e518a0f398ab7c85d0c1baea3fa0d97acf7df6991cc"
    sha256 big_sur:        "fd38ad711a97465dce01253d8007420f69f5b6c7c42d5abddcc9b410fd6c472b"
    sha256 catalina:       "4b907b17d270ea6f8b7f2286a7623cd328bb7cecdefe5d87e6962955192f94ad"
    sha256 x86_64_linux:   "139c854156751a7d928e02ec38fa909c3fa32b73e9211795c12c078302bd5b14"
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

  on_linux do
    depends_on "gcc"
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
