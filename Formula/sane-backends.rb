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
    sha256 "687b773de141d0d79fbf16d882be2066a2fcdf4056ba86803fb40669752e2c79" => :high_sierra
    sha256 "0af3374d96090f87e273ee9446154a481bc3c8461b81659ea54710e3cd6b39c3" => :sierra
    sha256 "ff90535945b9082a1d47b22535b31135b3622e61280c73d0194516e1e1d31605" => :el_capitan
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
