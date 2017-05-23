class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://alioth.debian.org/frs/download.php/file/4224/sane-backends-1.0.27.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.27.orig.tar.gz"
  mirror "https://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz"
  sha256 "293747bf37275c424ebb2c833f8588601a60b2f9653945d5a3194875355e36c9"
  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  bottle do
    sha256 "9ae23943f94606cef5b487b13316de6315b1902649c4b727a1e2fcb3b7cff6f0" => :sierra
    sha256 "69f378b3f6de3b875e1a1faa732f1ed42a7c76e79f47f0e4b642691f3a166140" => :el_capitan
    sha256 "3eb8383ea5af581ae71a5179432c0d654f2001922f7cbd747d2e5e15165eaf2f" => :yosemite
    sha256 "37f8e076bdddbdc868076456c308d21fbbef40ab647297f69bf5ca4b88a07688" => :mavericks
  end

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"
  depends_on "net-snmp"

  def install
    ENV.deparallelize # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
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
