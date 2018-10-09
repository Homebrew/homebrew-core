class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.5.0.tar.gz"
  sha256 "92aa56cf45e25892326e98b851c44de9cac8559e208720e579bf8e2cd1c132b2"

  bottle do
    sha256 "08706b58638ef1705eb815a68e98d1a7cb84881b947dec37fbcfedf3ed7e33c6" => :mojave
    sha256 "e19ba4dd4666be95b69981a798814108b11ca706b20e479990feee05babe7014" => :high_sierra
    sha256 "5e69215d66ff6210d6c100e673194140c45d356bd810f5061d6e123cbba9a63c" => :sierra
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
