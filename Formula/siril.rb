class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.9.tar.bz2"
  sha256 "7958985393eca33b2db173090af78a46e42a7daefe7f6eaa7efa4ba261fa46f3"
  revision 4
  head "http://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "3540ee3f5a7b6d2b4df41c31ad540c853e987bfd66ee93904fa5eff706d5115a" => :mojave
    sha256 "beba57ea5812e1e2c004fb1f6e52631a45423bad1b8fee7a88f8515d509e26bb" => :high_sierra
    sha256 "1a55c8b5faf1e27e30d65d0a565f632c66f8fa4745fcd203912ed0cc5f6002e2" => :sierra
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

  # Upstream fix for compilation with OpenCV 4
  # Remove in next version
  patch do
    url "https://gitlab.com/free-astro/siril/commit/c23c2cc829b2ad9444ccefeb865f7e1b3d49c282.diff"
    sha256 "22e179e832c7f6a28d5f2bfb3953be477b15450df41ceeb353b77376bec7e048"
  end

  def install
    ENV.cxx11

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
