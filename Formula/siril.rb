class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.2.tar.bz2"
  sha256 "4973bd7ad6d3cb7ad279ef27bb5c79f37ca1f914c7b6ad8fe689e1d59189f2db"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "22d4024bdf6c6a92f69cc4785de754a63a4fc3a3e8c434fe231baec95cb5d441"
    sha256 arm64_big_sur:  "a05177bad10efd318449482d5b5e4b824def6bebefd0645d8b0b824c0ad06181"
    sha256 monterey:       "9f9b607d8a6522d7a6c6cd0c3a38e1f93738347821f454b8fc71ea908ead12f3"
    sha256 big_sur:        "f46751fc469b4ffb7d34ea0b132e35d7ef22eb90ec761422cd237ff683b0d101"
    sha256 catalina:       "0564b4640b9a0288b5ca94c25703d3f707ca1059798e42d30c5aa39a757910bf"
    sha256 x86_64_linux:   "1c840bd41181faee8564415560e711b0ce0a35e231f17cf5a420ddc3396bd90c"
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
