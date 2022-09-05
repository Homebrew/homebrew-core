class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.4.tar.bz2"
  sha256 "11aa4e491e42f606301d214ffec35741ac6522b5a94feab04fb701e829fd5aee"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "0339a4f28df727635479720958fb5da558da93960409d639d12ebd45f9c7bd11"
    sha256 arm64_big_sur:  "bb49d00b35324745eee167bcc010c82999f4b6d864b6dbe2ef1a9e698ef60de2"
    sha256 monterey:       "d567d7a25ae27bb93d985962521f752e612786ede4566d8ee8c1d6511603022d"
    sha256 big_sur:        "ff5ffcdab3087322b0139187ea6b85a9f80a682235726c5b1a032eb000d77af4"
    sha256 catalina:       "158766c424480f28d888bbf8c8855e06e14687796382936bc3b2ab573ed8dc65"
    sha256 x86_64_linux:   "a6e7148c82f7ee2a3669a7675622835da9164eb8ecabda2e82ad79d1cd6a192a"
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
    system bin/"siril", "-v"
  end
end
