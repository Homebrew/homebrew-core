class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  revision 3

  bottle do
    sha256 "c94386e2985c9a4175aba3280658670810269c0a6fe8315676cc49198070bf14" => :mojave
    sha256 "eecee1fb605e34564d8906a72f41d1516a210cb41af86c9dd51cdd05376d8b48" => :high_sierra
    sha256 "5c9c512b8267d66e69842e9f11b9f63169ae2b953108df72f200122267724f9d" => :sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/xboard.git"
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
