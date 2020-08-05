class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/v0.19.tar.gz"
  sha256 "0550c12266ac524a8afb764890c420c917270b0a876013592f608ed786ca91dc"
  head "https://github.com/kilobyte/termrec.git"

  bottle do
    cellar :any
    sha256 "1d93149ec34c0bf531da76b0137390ed1f05bf2e35e806f1fe875fe6648c4c2b" => :catalina
    sha256 "e3f9f241763a05de367da2ee91727674e18a126a99480a750b901a21bdad0ffb" => :mojave
    sha256 "d6cb43ed14ec0531824bd4eb55ddc625b5711c28b274ce78eb815501e5f3ebf2" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    system "./autogen.sh"
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
