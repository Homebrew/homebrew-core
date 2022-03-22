class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.0.tar.bz2"
  sha256 "22fec7b88b94c40c4180e6637fef8a7cd8ea95ccaf23323e403bf2296ec274bc"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "0e4730f0cf0562b0e41f0c616306cffeb1689d5579cb27e5bc1c8c22fd6378a5"
    sha256 arm64_big_sur:  "f0d476195f5e9b774a66e50b0c570f3848c3d1deb79ae0317a639a18736d839a"
    sha256 monterey:       "128fe97ac7e24b8ff62f5bcc9aaa70dc6f2aa46ab66b2e7074d85f79b8c652bf"
    sha256 big_sur:        "fe9ff9717c8d47434bfd4d8f13c21f88c20f3fdb9e4f20c6ec6672d85dfe77b8"
    sha256 catalina:       "3bc0fcf0a02ebd5cf11afd7bdb1171398b7e8334275c48dade16b5281d31d85d"
    sha256 x86_64_linux:   "05c6643e3dcbee57cbac0ce83c0c234a23d3f6730b4b103256f03ed22083368c"
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
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gtk-mac-integration"
  end

  on_linux do
    depends_on "gcc"
    depends_on "gtk+3"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

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
