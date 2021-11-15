class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_big_sur: "87ddefe504448f88254af63c0eaef51f4380f76ea1d2f20fcf6ee780b9241b18"
    sha256 monterey:      "cf88692979c82a3d4697dea0db80d433fc7c9c11f4e4bdfa4d104c88fb6f4f47"
    sha256 big_sur:       "cd3b5c0a0ee1045a4ba3dc98077a2ed01fecb281bc6763ecd509b6f09efaf173"
    sha256 catalina:      "561953a63ec6296b6faeb38b999f83ede6ba7c91501cce88eeb560c282985ee7"
    sha256 mojave:        "c94386e2985c9a4175aba3280658670810269c0a6fe8315676cc49198070bf14"
    sha256 high_sierra:   "eecee1fb605e34564d8906a72f41d1516a210cb41af86c9dd51cdd05376d8b48"
    sha256 sierra:        "5c9c512b8267d66e69842e9f11b9f63169ae2b953108df72f200122267724f9d"
    sha256 x86_64_linux:  "928cc685fd1d687167a7135641340cb53885c54323aa6c005c67c0119caca0ed"
  end

  head do
    url "https://git.savannah.gnu.org/git/xboard.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fairymax"
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "librsvg"
  depends_on "polyglot"

  uses_from_macos "texinfo" => :build

  def install
    system "./autogen.sh" if build.head?
    args = ["--prefix=#{prefix}",
            "--with-gtk",
            "--without-Xaw",
            "--disable-zippy"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"xboard", "--help"
  end
end
