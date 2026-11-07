class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://free-astro.org/download/siril-1.4.5.tar.bz2"
    sha256 "ed30edc3535d6f8fde2cf84f23039db7c87380f16df740936bdc75362fa50a6d"

    depends_on "gtk+3"
    depends_on "gtksourceview4"
  end

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "fa8880730ba8f64b99d850011e287b7abab66cef5225913c1c1347834bf0b100"
    sha256 arm64_tahoe:       "66711a55eb413d0742ec8bf155b912619cfe006168cc7f1995f43c3c24f8949b"
    sha256 arm64_sequoia:     "5cc2577b70bf4d042ee44e4882201c3a81057d2cc5df8ee8b001bae798ab5f2f"
    sha256 arm64_linux:       "524b882a3f4e05cfc0bbf53d7925f8a98972d896bf836b04d7533cf7a1728386"
    sha256 x86_64_linux:      "268a2fb79a07bce00062a1fd4104c092ec71225014b8d2d268be50518028fdaa"
  end

  head do
    url "https://gitlab.com/free-astro/siril.git", branch: "master"

    depends_on "gtk4"
    depends_on "gtksourceview5"
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
  depends_on "gsl"
  depends_on "healpix"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libgit2"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "little-cms2"
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

  deny_network_access!

  def install
    # OpenCV 5.1.0 removed `Mat_` comma initializers, so build these vectors from `Matx` instead
    inreplace "src/opencv/opencv.cpp", /\(Mat_<double>\(3,1\) << ([^()]+?)\)/, "Mat(Matx31d(\\1))"

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
