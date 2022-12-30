class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.6.tar.bz2"
  sha256 "f89604697ffcd43f009f8b4474daafdef220a4f786636545833be1236f38b561"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "d44913848625d9b708c1b656ff9f168cb82accbd0b9da013b5b474f7a4f6456f"
    sha256 arm64_monterey: "bca60366348a73e27556c01bf4e6e0ac8033b0ab90d2e79802138b5d1758ed35"
    sha256 arm64_big_sur:  "62021482cc915194c59c0915e802477acf06629c2101abad042d843dd4df39a0"
    sha256 ventura:        "6b7d762271abcd97eb1af88055461000b4e91991ca6f09eb944033e3ca13ce09"
    sha256 monterey:       "8c5e9b7fbc0970fa01b8ee14fb94d71a4de502d89eb3d9b0befc3ea1ff034fe3"
    sha256 big_sur:        "48033b8a87053b8c36d19d8d2baf1049b16b28a28f20334145a410594d29f1ea"
    sha256 x86_64_linux:   "dfe3b6475f8a7b65cf60abae759739bf556b37bf2024d39d66a302c27101bf82"
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
