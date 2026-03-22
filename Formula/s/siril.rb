class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.2.tar.bz2"
  sha256 "451915627ae461ef992ac0f83bd3ff1db5102d72ca379eee55b9be4f12b1162b"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5f199ace91220b7f43bd12efcf51ab4b33da66c096feee738f3c015e7323b811"
    sha256 arm64_sequoia: "ccb7efbcdd1bb193eab243028a51597084210998d168715634430fbb6e25ac8e"
    sha256 arm64_sonoma:  "b2a74c84d13c354cc5a7061d600abebd59e49ac7e30777f5da5104c30b92b983"
    sha256 sonoma:        "9c95d44b1d3e76166f6092fb88c88b0b2569acc8c16494c46966149678deb446"
    sha256 arm64_linux:   "04f87cb1e750024be8f00098967e289a5826d0799edaaa7ec7f81f31b6c51ae4"
    sha256 x86_64_linux:  "04cc15d0adddc4a30eff2ce38a215f531ee07bb6e343dab197b0b9d825b06bc4"
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
