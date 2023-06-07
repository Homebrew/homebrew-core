class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  revision 5
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "126c445d68ba6200bf8c5b989c61c0bccb5a09d9124a7a199fedfc198ea58f2f"
    sha256 arm64_monterey: "51647310dffa86ab927d4c8521fb91869a300b7f4d920ca8764303a84819ac25"
    sha256 arm64_big_sur:  "4fbfe0e8911a22504affe516a1b405d883198b335b6d0c22f5b57f5785d1e912"
    sha256 ventura:        "1a8b857a270a17f14798dfc6e37f13db4ca46dcef55d9a0be9a68145fdef90c6"
    sha256 monterey:       "f2a87be9107fb513a96fdb37733bd581c05e59c4dcc5ffa3c570d3483f6a9d2d"
    sha256 big_sur:        "92b7ea9150156a11ab91ee4beed8dc19195a6df9d253d158c9261258e1534705"
    sha256 x86_64_linux:   "e24ae5043ee05d68e4dd4392970d00890ddc087d3c9ac5a58fa07e207278eb40"
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
