class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  revision 6
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "66c27aed373b70de3f1bc7228df975f7f922a5f32de34cf2ec5e8b09656d2699"
    sha256 arm64_monterey: "ae9b4b4c509d42468bba2b9679548cb7ca95a6ab53ee4281b117a2b234df3114"
    sha256 arm64_big_sur:  "981831e301be68ed88d88f643382d6910a3af73e415707d7f8139f6ea49eaeac"
    sha256 ventura:        "1b53ac492e325fcdcf6fcc3a269f60c4ef16fb0865dcf43ba3686ea66c539075"
    sha256 monterey:       "6bd35708611e01d0af16bbd75c609aa954b0fd5626ba22e81fd8da500e5613e1"
    sha256 big_sur:        "3d7f42d17bf4ce6ca04441493cbbf12302a4d8d82306db6fd8fa023098bc7b2c"
    sha256 x86_64_linux:   "3aa74da5ef8c87f59c8c0aa614c874f762d41cdf5b8a5811c093ff2c33293ee8"
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
