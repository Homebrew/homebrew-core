class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://alioth.debian.org/frs/download.php/file/4224/sane-backends-1.0.27.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.27.orig.tar.gz"
  mirror "https://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz"
  sha256 "293747bf37275c424ebb2c833f8588601a60b2f9653945d5a3194875355e36c9"
  revision 1
  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  bottle do
    sha256 "5abe83de7d4deb0e9710aa2d21d4e80ebde98965f09a6460ba23fe6a90bd6046" => :sierra
    sha256 "68fe8f9d3db39e1c28fc06dd8d2766b6889c7a269be0067fb53892673d47ec97" => :el_capitan
    sha256 "19bbbe725bb8fa139134a0c999eb0bad22bc1a48998148632750adc61a7dbd21" => :yosemite
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
