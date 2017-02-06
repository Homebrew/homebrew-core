class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  revision 1

  bottle do
    rebuild 1
    sha256 "7004805cccc01a3e0d627c6781975e79a8659078059a11f12bd748bd0e281498" => :sierra
    sha256 "6a41c3769384e668db117dd681ea1b40f5b3167ca39bca1b1df71fc655a60db4" => :el_capitan
    sha256 "700ba70a1ba19ce440c9daf3132f43a655d20fa1e9c7da80066145024469f7f0" => :yosemite
  end

  head do
    url "git://git.sv.gnu.org/xboard.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fairymax" => :recommended
  depends_on "polyglot" => :recommended
  depends_on "gettext"
  depends_on "cairo"
  depends_on "librsvg"
  depends_on "gtk+"

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
