class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://alioth.debian.org/frs/download.php/file/4224/sane-backends-1.0.27.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.27.orig.tar.gz"
  mirror "https://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz"
  sha256 "293747bf37275c424ebb2c833f8588601a60b2f9653945d5a3194875355e36c9"
  revision 4
  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  bottle do
    sha256 "ac27058e0edd6bc0af11af3de0703169ce4508ba9840a598155bc1fcdccd00b5" => :high_sierra
    sha256 "2fce948374f59735fc55c2ef4803f44fba0ac9979943dadc30d11f9a262c6fd2" => :sierra
    sha256 "2faeb4b16e4e2ea851c1cfc100d8deedea3bb042ba3b21b66ba2865812500479" => :el_capitan
    sha256 "68242fa7feb502d1b5001df7db05837268085f6f97e58768323566e671ac59f9" => :yosemite
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "openssl"
  depends_on "net-snmp"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--with-usb=yes"

    # Remove for > 1.0.27
    # Workaround for bug in Makefile.am described here:
    # https://lists.alioth.debian.org/pipermail/sane-devel/2017-August/035576.html
    # It's already fixed in commit 519ff57.
    system "make"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
