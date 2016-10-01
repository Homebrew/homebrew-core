class Submarine < Formula
  desc "Search and download subtitles"
  homepage "https://github.com/rastersoft/submarine"
  url "https://github.com/rastersoft/submarine/archive/0.1.4.tar.gz"
  sha256 "c4fbe0786be9aeab95d4df4858f890fae3ca3c06bb28993ae1cd38aa20d1a801"
  head "https://github.com/rastersoft/submarine.git"

  bottle do
    cellar :any
    sha256 "4c57d03fde5cb8ee472f9570d88cc8e8987fbf9280b95ebfe78427fde913e72f" => :sierra
    sha256 "36f4b8efc06f041c77315cffc8739bbead67cd501208c93f168893f295a70f94" => :el_capitan
    sha256 "98e2e4d767aacfb27e6989d1205cb2489b52222ea4f5586e89c0366e4721278b" => :yosemite
    sha256 "317136a44b158c1881eef04c5942c4868575a0fc46095955beedda56d3e7527e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libsoup"
  depends_on "libarchive"

  def install
    # Because configure is looking for libgee-0.6 which provided
    # pkg-config viled numbered 1.0.
    #
    # See https://github.com/rastersoft/submarine/pull/1
    inreplace "configure.ac", "gee-1.0", "gee-0.8"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/submarine", "--help"
  end
end
