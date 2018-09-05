class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.4.0.tar.gz"
  sha256 "26aac12bdeaacd15722dc0a24a5a1981a3b711e61d10ac687a23ff0b7075da07"

  bottle do
    sha256 "2801e74e266fb66c378243b526c36880b6045433a2d7f8f52562297eccd51cf0" => :mojave
    sha256 "90398dd6808c3395df2e23b106e7805667ac822591429cff84d8e8a9693e644f" => :high_sierra
    sha256 "ce54bf78ae49fd506f3e6ea801cd581210331155cb9be55fc8c306602812d85e" => :sierra
    sha256 "78c25fdc54c0c1cc64c4099f319c56941fbd91aa1404a8b69163a03a397f5e74" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/softhsm",
                          "--localstatedir=#{var}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  def post_install
    (var/"lib/softhsm/tokens").mkpath
  end

  test do
    (testpath/"softhsm2.conf").write("directories.tokendir = #{testpath}")
    ENV["SOFTHSM2_CONF"] = "#{testpath}/softhsm2.conf"
    system "#{bin}/softhsm2-util", "--init-token", "--slot", "0",
                                   "--label", "testing", "--so-pin", "1234",
                                   "--pin", "1234"
    system "#{bin}/softhsm2-util", "--show-slots"
  end
end
