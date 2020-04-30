class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.6.1.tar.gz"
  sha256 "61249473054bcd1811519ef9a989a880a7bdcc36d317c9c25457fc614df475f2"

  bottle do
    sha256 "6191b8427b45b0d497df2442326a1ef771d780528a1af630283921314631d7f5" => :catalina
    sha256 "b3df4c2a1b79e2f741a364be111653d49cf096335ce81597a1fed376368c19ee" => :mojave
    sha256 "a6b0ca9197123c0e13bbcf8e29e42a2b8bb6b3288b8b953be244ce9d3d0cb920" => :high_sierra
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
