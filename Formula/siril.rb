class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.10.1.tar.bz2"
  sha256 "a0b3debc1efb313a84958fb1819b3a5d0a1395b096db54cce7e3e34a463a5c79"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "8917ab63cdff809d77899b5c4ee9db471826f2b9569800d2e4f30695ae7dca2b"
    sha256 big_sur:       "3731dcf2047e89cf8e0ef788ef0356a6039a386fceb3248e32dbca060e88f615"
    sha256 catalina:      "a51082e5d3bbcae83fb3f7d2a7fd175cf030655ce4e5e9c6ec03e0929287e99c"
    sha256 mojave:        "fcb5c6b1232af882056b4cc908f291e94e3f16987cdf8870bca93d74e13cc8b0"
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
  depends_on "gtk-mac-integration"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  def install
    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
