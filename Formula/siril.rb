class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "e0dc10be674471441b1bdf17334582cbcf927169e088d5962a86223b84d92588"
    sha256 arm64_big_sur:  "363c451176ab23459568cbf6c31c84fa9ff24026c38ca44f671e0cffa1c3277e"
    sha256 monterey:       "9cc7ce4042232c80c6fd6feaf8e2189162be550d514efc4eeb01cb63e33d3661"
    sha256 big_sur:        "d17a42f115cd8093c55eacb63ee06ab961c58e3b033485882388232f461881f6"
    sha256 catalina:       "37ce14f936455a5b3f70818495cbaf50312c5851c48f751fb31fdcfdae1aeae4"
    sha256 x86_64_linux:   "7e88d1a3b045ecb2e2dd53458da0f0fac42003b72cfc93a7187e11cdff9d935c"
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
