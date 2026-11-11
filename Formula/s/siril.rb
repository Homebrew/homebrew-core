class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  license "GPL-3.0-or-later"
  revision 2

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
    sha256 arm64_golden_gate: "8587ebb5b886d51cab9b142512ca5d2abdd2e130025331ba98d9245dbcf69b76"
    sha256 arm64_tahoe:       "60743f6e38bfe6c96d4356bc2577af1fa698d43b43fee669797a81bfa316096d"
    sha256 arm64_sequoia:     "9339d7e28a329aa22d59d8a3f371654397519d7721b4ac5af82bfd9e95396cab"
    sha256 arm64_linux:       "e677d1f0cc85d276753678da304ebc72e43009e37e64737c39aefe4cd3040003"
    sha256 x86_64_linux:      "168ee661310e8a6b5ba79aa72b3bb260a3d9b113ebae5f33381fd4dac1d2063b"
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
