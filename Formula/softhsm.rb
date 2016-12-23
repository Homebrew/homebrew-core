class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.1.0.tar.gz"
  sha256 "0399b06f196fbfaebe73b4aeff2e2d65d0dc1901161513d0d6a94f031dcd827e"

  bottle do
    sha256 "6d50085c72282396e0d850a440c307130dae3087cc7ed21376d219184278c258" => :sierra
    sha256 "562ec5baec50d318c7eae4a2f12def095008c19d24d359d05e794e0fa17212fa" => :el_capitan
    sha256 "39f1bc348f541d122a8bd03d978be09ca971f7e9373707c26e9ba82eee262563" => :yosemite
  end

  depends_on "botan"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
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
