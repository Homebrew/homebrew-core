class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  revision 1

  bottle do
    sha256 "ce934b1de969ab76b7d1489e4add089a1a66bf26185327fadcf4473f3299b9c4" => :sierra
    sha256 "54ff402cf8bac6abb94fb273f4a34a1bb09e86b0dd667980caf54b65bb8871b8" => :el_capitan
    sha256 "544d69938d2910da76cdc16b76bb5f02b3e4c47b128242cdeda86d4cb7f52db4" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/xboard.git"
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
