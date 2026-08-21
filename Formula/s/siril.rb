class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.4.tar.bz2"
  sha256 "b1682f2129d2e06b034445ed225766a06e38cfaa7451b92d606a3ee36eb077a4"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "79f0432d71030f24f2d61ee3ec3133120c7152a82c781f582614ed7b742f9b05"
    sha256 arm64_sequoia: "f0c7f4a4fd7e2a808ca653658a89b01090b2f5ea73fd454933b3e873b462a14c"
    sha256 arm64_sonoma:  "9875c99864be912d6ff46ca851041095c9c1e775c56637e282704ff61a8d1656"
    sha256 sonoma:        "4e48ab315e239eb2c48286e5ae2161f644938f61c15a80b0f86517555c59cc6d"
    sha256 arm64_linux:   "4c825693969a87f660ba20308cb4df2e0c1cfcd3a746a9d827e923f38beda642"
    sha256 x86_64_linux:  "4ecb1ff88405db5f59aec103935f1faa37b83f7386cf26d17edffdee8c17012f"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffmpeg"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "healpix"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-glib"
  depends_on "libgit2"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "pango"
  depends_on "wcslib"
  depends_on "yyjson"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "libomp"
  end

  # Build against opencv 5.
  patch do
    url "https://gitlab.com/free-astro/siril/-/commit/743956900c65129ab12421951781c12b94c6e996.diff"
    sha256 "c07b0e62efea0c9622808992bbee77a9e707fb5aaeebf4cd44d9c9a6e680a7c0"
    type :backport
    resolves "https://gitlab.com/free-astro/siril/-/merge_requests/1073"
  end

  deny_network_access!

  def install
    args = %w[
      --force-fallback-for=kplot
      -DlibXISF=false
      -Dcriterion=false
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"
  end

  test do
    system bin/"siril", "-v"
  end
end
