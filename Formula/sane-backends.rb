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
    sha256 "b158d08da265fa785dbfe891783a1e0575ccf8ff646e40a2b9c972977cb24d6e" => :sierra
    sha256 "8b89353a9b469274fdaae8db3a9db0e0d0f849dba3ad330b38f4d2231b249f16" => :el_capitan
    sha256 "01faa0abace63ef385f29ba58975a7b2ca215aff206949175b493805dd2d983b" => :yosemite
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
