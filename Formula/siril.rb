class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.11.tar.bz2"
  sha256 "d30e40eed82af9d8e4392c5d888047b1a87a1705514444da3f319845b0652349"
  revision 1
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "d45f86fb7914bb91bdcdef896bdc64691cc91b5af3a68f36867df146740912b7" => :mojave
    sha256 "567160dee590d89cb85b50363c26c0cbbdb59660722096ecd523bb6149d04a59" => :high_sierra
    sha256 "f9235c71ddb62be851fad36d1bfeaed693394e7625e39f45a8538c3c651985df" => :sierra
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
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  def install
    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
