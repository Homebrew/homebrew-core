class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.5.0.tar.gz"
  sha256 "92aa56cf45e25892326e98b851c44de9cac8559e208720e579bf8e2cd1c132b2"
  revision 1

  bottle do
    sha256 "d924a3f96532b0cf983385a97a72fa2c6909f8f8e7b92dd5788a81f71bc20d9c" => :catalina
    sha256 "ba2efed59b5064868a7198dc51aa9be15070bf34ef3c09d8de40c64c7c9bad5e" => :mojave
    sha256 "45fcd165092f402571d77d28ec07e7b16ac4b257b72f87a29174ac614f89336e" => :high_sierra
    sha256 "d42f52da6397f57e84da014d62411d7b4fe7afe69dff63947c53054d6f66de6c" => :sierra
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
