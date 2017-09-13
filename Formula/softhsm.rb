class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.3.0.tar.gz"
  sha256 "5ed604c89a3a6ef9d7d1ee92c28a2c4b3cd1f86f302c808e2d12c8f39aa2c127"

  bottle do
    sha256 "9c13086544e0a554bfe2a687cfa0b05961e84260407282f4c4198dfb8dc6bc04" => :sierra
    sha256 "066d911caa4a4961939403d8f08c1862a947046e5bbc042edeb9ce9a37f8116e" => :el_capitan
    sha256 "53cad8948c14774fc54d21c241225f4d9a32bc6c98dfc74b7888420a4c0290be" => :yosemite
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
