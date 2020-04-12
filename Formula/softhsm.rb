class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.6.0.tar.gz"
  sha256 "19c2500f22c547b69d314fda55a91c40b0d2a9c269496a5da5d32ae1b835d6d1"

  bottle do
    sha256 "d924a3f96532b0cf983385a97a72fa2c6909f8f8e7b92dd5788a81f71bc20d9c" => :catalina
    sha256 "ba2efed59b5064868a7198dc51aa9be15070bf34ef3c09d8de40c64c7c9bad5e" => :mojave
    sha256 "45fcd165092f402571d77d28ec07e7b16ac4b257b72f87a29174ac614f89336e" => :high_sierra
    sha256 "d42f52da6397f57e84da014d62411d7b4fe7afe69dff63947c53054d6f66de6c" => :sierra
  end

  depends_on "openssl@1.1"

  # Fix macOS compile.
  # Remove with the next release.
  patch do
    url "https://github.com/opendnssec/SoftHSMv2/commit/0601e4014dc2c1296b25d4868f8d7a50c0e31e75.patch?full_index=1"
    sha256 "e860d142e8e6aa757b381789d8aad0bae09f93caed3ae37c3fc67dcefea18099"
  end

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
