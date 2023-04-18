class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  revision 4
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "a1e61bcc0bb32520b1b9b8255500c32b188da7aaa20e8aea3baa1adcd6579edf"
    sha256 arm64_monterey: "420220523d6648c223162c25498c98c395e08455f528c31fa1ee383fb17d582e"
    sha256 arm64_big_sur:  "632341a42a62c423f0e92bc3162f53fb3a5f3a0e90ef78f6fc011611057685ae"
    sha256 ventura:        "303ebd5cd1d23b53acf500fac23da76041bdab3ba21feed039f25f4b4e82c8d8"
    sha256 monterey:       "069ea7959984e257c15755f6eb0469d1a1e1a2ea43af4a159135497b3db875fb"
    sha256 big_sur:        "b2bc5c628652dd0679d63c9edf69d210767a667b25b9af840cc3f15e7860f1bf"
    sha256 x86_64_linux:   "c3ef4597658a61e4c6ff0f7837c65e64ef516fee50ca4dd0403869eca31c55eb"
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
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"
  depends_on "wcslib"

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
    system bin/"siril", "-v"
  end
end
