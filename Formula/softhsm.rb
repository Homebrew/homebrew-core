class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.3.0.tar.gz"
  sha256 "5ed604c89a3a6ef9d7d1ee92c28a2c4b3cd1f86f302c808e2d12c8f39aa2c127"

  bottle do
    sha256 "59d5370c78d7efec097ec01bbcdd45b6a9d03fbfcd25ba95eb6bb339f69fbeec" => :sierra
    sha256 "f85bd50478506c2b885e1170ff7ad2761663d82ff3ffcaead3726a79358a3aea" => :el_capitan
    sha256 "64c03ef2f241c633f8b74987e89b09274d590147629c7c292fa209f821c01947" => :yosemite
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
