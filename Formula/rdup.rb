class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    sha256 "c198ebca564d97de07f9571c296c93239a58dbc195648e9c6eb25e5ba8c363e5" => :mojave
    sha256 "9a5c191bea14d721e49d5622567104e6fc1b6e6c3326e528ba8a08498fb66c46" => :high_sierra
    sha256 "43582c3cc5fb02bb50a73d71963045fa27cc38d03eed2e1e57d915a7f5c162cc" => :sierra
    sha256 "c9afd06e3d3cfb9628c9618723d1913916f2563d2b18159cffe2b2586ce0c508" => :el_capitan
    sha256 "0b83116666ac22439d46a6d92f6d75eb3dd7f231021dbc441c2388b4bd076e00" => :yosemite
    sha256 "ddfd0b0a7116c618739caffb054a0b149e17c7bf517c512ccb1543c3e7784275" => :mavericks
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
