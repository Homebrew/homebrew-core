class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.6.1.tar.gz"
  sha256 "61249473054bcd1811519ef9a989a880a7bdcc36d317c9c25457fc614df475f2"

  bottle do
    sha256 "69963f95aad110c6dcadab15613ee928f1358b714d71f4e7252da9b885eac7cd" => :catalina
    sha256 "4a17c51934b0adc317cfc49069d52b3fa2fcb9a852808a7b0dfe2de28cf4b3b3" => :mojave
    sha256 "cd17fa2e8538ca99b5963d60074578c91839740e7f87cc292b9b8f4f67dd99d8" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/softhsm",
                          "--localstatedir=#{var}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-gost"
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
