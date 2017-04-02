class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.2.0.tar.gz"
  sha256 "eb6928ae08da44fca4135d84d6b79ad7345f408193208c54bf69f5b2e71f85f7"

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
