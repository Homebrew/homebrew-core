class Termrec < Formula
  desc "Record \"videos\" of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/0.17.tar.gz"
  sha256 "e3496dcb520b63036423cc72f3eaf66f690e869ef4ae508f027923062c34d84f"
  head "https://github.com/kilobyte/termrec.git"

  bottle do
    cellar :any
    sha256 "945043d319c728bfb239514c13407816dce87c1ad2f6b2b4cd8590d9d5c7dc86" => :sierra
    sha256 "787ed19e10d093b52b4aab2e6962480ea26b02ebda78bffb54258ce585c31ce1" => :el_capitan
    sha256 "53f6c1350027212566b1bcd5bb632a5cc5a9fbd56954b619a9bc0a96dd587bb4" => :yosemite
    sha256 "ffcb4996ef7e88fe41fef79289a65aa9d797e8ad10b7cc382fabc479d504bc31" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    inreplace "autogen", "libtoolize", "glibtoolize"
    system "./autogen"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/termrec", "--help"
  end
end
