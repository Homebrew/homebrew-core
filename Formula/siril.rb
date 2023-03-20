class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "0bb50849eca23e336fa214632abe2df5da04407be6c91a6eb38e09d19e8e0d14"
    sha256 arm64_monterey: "55e5c2bdaf0256935ec6e9ccfb88a4e7394736290be1364535ef64c6b3c16cfe"
    sha256 arm64_big_sur:  "dab8720f082eb04250f29c79f7de88ddca32fec5bea9378bd8e1292f496030ff"
    sha256 ventura:        "5afeefe2f7ffd6ee19fd072e8b2047fc0abdda26482ebcd4ee23f316dc484aa9"
    sha256 monterey:       "85390fc80b31f80a6e8487f2f7d242a79f38006df3acdaff586d13b5379c73b9"
    sha256 big_sur:        "e8c49673d2f5ae1bc53565683a1402c2a954229833c46d185e9f51577cd23903"
    sha256 x86_64_linux:   "86d4982ced6094220c409005d53e702951a08d6d2194f537427e9a295d692acc"
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
