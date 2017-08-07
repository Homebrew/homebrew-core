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
    sha256 "472089888e262906b4321c2ddc5ec8994d72100d76e3925ac5ebdd494c7b61f2" => :sierra
    sha256 "ba577c1caaea98833d48a3a954435f5d0b6df10305a5eb5e90aad2a92d974cc3" => :el_capitan
    sha256 "adff75a9de31cc2d957fb81c18ce025f0c8be6a56c942b21e3724a818f9b6970" => :yosemite
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
