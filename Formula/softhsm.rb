class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.2.0.tar.gz"
  sha256 "eb6928ae08da44fca4135d84d6b79ad7345f408193208c54bf69f5b2e71f85f7"

  bottle do
    sha256 "6d50085c72282396e0d850a440c307130dae3087cc7ed21376d219184278c258" => :sierra
    sha256 "562ec5baec50d318c7eae4a2f12def095008c19d24d359d05e794e0fa17212fa" => :el_capitan
    sha256 "39f1bc348f541d122a8bd03d978be09ca971f7e9373707c26e9ba82eee262563" => :yosemite
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
