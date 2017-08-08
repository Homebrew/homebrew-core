class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://alioth.debian.org/frs/download.php/file/4224/sane-backends-1.0.27.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.27.orig.tar.gz"
  mirror "https://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz"
  sha256 "293747bf37275c424ebb2c833f8588601a60b2f9653945d5a3194875355e36c9"
  revision 2
  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  bottle do
    rebuild 1
    sha256 "40f3d76b4f2d1dff26c54e370363e10559a46d79ba2c931716cde97cadd26209" => :sierra
    sha256 "3aada5f45cf23b055afcd260e7bd7abcd04258166d6a682cb796778af66e3970" => :el_capitan
    sha256 "23d0dbe7ddf5dcf3a2e37f95c19014a44b31431e6b080bcd771f07ef6b50f97f" => :yosemite
  end

  depends_on "jpeg"
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
