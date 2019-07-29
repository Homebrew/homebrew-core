class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  revision 1
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    sha256 "10160aeeb73f78719894f7d95e0286975e77b7778acebb0150256fd0e83d0931" => :mojave
    sha256 "2bc9ea46a7792c1c3f4d0b8d220e7712876e9847973a32dc948079c72045a0e3" => :high_sierra
    sha256 "bb7077f739d9ba32ff6b1017987ebffc9b9e4081c6d3dd36e56f0193c9e9e4e7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libarchive"
  depends_on "mcrypt"
  depends_on "nettle"
  depends_on "pcre"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # tell rdup to archive itself, then let rdup-tr make a tar archive of it,
    # and test with tar and grep whether the resulting tar archive actually
    # contains rdup
    system "#{bin}/rdup /dev/null #{bin}/rdup | #{bin}/rdup-tr -O tar | tar tvf - | grep #{bin}/rdup"
  end
end
