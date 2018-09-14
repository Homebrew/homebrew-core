class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  revision 2

  bottle do
    sha256 "68471e095e3cd698e3e461d1072a8bbfbcb63da8fc6edaa4d9d8bc0f46618758" => :mojave
    sha256 "00118aebe71d62daeb3b57f2112dc8f86dcc94cb885e7087b10f609a0307b73b" => :high_sierra
    sha256 "4a50ceee531601a9a920ca1a2d099113993b0369e5b76fe4125ba43563c2b04a" => :sierra
    sha256 "47d20242d82c9223754908ec0a7443ea5f7774a82eaf43bfbeaacbda5c750ce8" => :el_capitan
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
