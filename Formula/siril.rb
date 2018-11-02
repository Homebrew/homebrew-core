class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.9.tar.bz2"
  sha256 "7958985393eca33b2db173090af78a46e42a7daefe7f6eaa7efa4ba261fa46f3"
  revision 1
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "2deeaab062cccff61daab38450128c53f79acb8acc83084b2a7b2cc59379a18d" => :high_sierra
    sha256 "12ab1e8589486cfb1124dad33dd15656c0ac80e5b4cc7685bf2054e0c7943784" => :sierra
    sha256 "45fbe1d7560c452438694d808b0aaddcc0d45069b3ef672a2c7fc8a0d5638880" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk-mac-integration"
  depends_on "jpeg"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  fails_with :clang # no OpenMP support

  needs :cxx11

  def install
    ENV.cxx11

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    system "./autogen.sh", "--prefix=#{prefix}", "--enable-openmp"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
