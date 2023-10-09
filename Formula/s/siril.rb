class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  revision 7
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "8c6cd7d8bd63127d2263b8b153dbe941b0ad9a7edde60885db558bd048ad74c8"
    sha256 arm64_ventura:  "208c71f56dff61d423588210968bae04e6a732466764353b46cd249b34dfe029"
    sha256 arm64_monterey: "7bde9251cba3965ca5be5a7160c657ed679957d579b2417ceb504d969ca39885"
    sha256 arm64_big_sur:  "5d96bce7246ddd5d51fc4bb812fd77b200cc8ddabc18dcc3b875c78fd76d0c13"
    sha256 sonoma:         "076e83a7d0b68b7408253fbd81a04097410b02606271589c5cfd8c15fe8493c9"
    sha256 ventura:        "417100a448f19ff66d112b370769e58547c5fa81f77ccc86b4b08033059f11d9"
    sha256 monterey:       "c279b428372f7aa09ef73904a59aced6f4aa422650987358bece360def465ffa"
    sha256 big_sur:        "7daf5062ee04e7bb033153df1d4f1124b993ab07b6641c4ade092e13d31d8e57"
    sha256 x86_64_linux:   "8c89cf9a837456760716b1be36b7280dde9ec4c1042ee3c6d24f00da0c4d70f7"
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
