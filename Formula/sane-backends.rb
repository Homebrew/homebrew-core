class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.27.orig.tar.gz"
  mirror "https://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz"
  sha256 "293747bf37275c424ebb2c833f8588601a60b2f9653945d5a3194875355e36c9"
  revision 5
  head "https://salsa.debian.org/debian/sane-backends.git"

  bottle do
    sha256 "19a5dd6aab043b2552e4ddb785c4f41c184019a7854e5bf28054ee809839a81f" => :mojave
    sha256 "7e17e4e13a6b9d4c532c3f4f498711c016c0c23331a25e9c4fe2543c1241bebf" => :high_sierra
    sha256 "c1c278d995f33f438ad6009ba4928157dd2ca74ec17a344a57b7af972c64e190" => :sierra
    sha256 "6073b7b25829eb031616894fe6ea5c34408fed9b42d3b421e6eba94d6cbbf948" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl"

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
