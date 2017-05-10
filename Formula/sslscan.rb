class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.10-rbsec.tar.gz"
  version "1.11.10"
  sha256 "fbb26fdbf2cf5b2f3f8c88782721b7875f206552cf83201981411e0af9521204"
  revision 1
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "74866c6955b5603ba494ffaa66c028e690e1cdaad792def87eccf13367c5c043" => :sierra
    sha256 "3294b6c4956bc565af8b714c5e633f5e5b7a05dd4d19a07d8ddaf1f90dcf2d44" => :el_capitan
    sha256 "0537cb08b5d621601741a9b92d9a0bcec978242b3ca5830711a49a3ebf99036b" => :yosemite
  end

  resource "insecure-openssl" do
    url "https://github.com/openssl/openssl/archive/OpenSSL_1_0_2f.tar.gz"
    sha256 "4c9492adcb800ec855f11121bd64ddff390160714d93f95f279a9bd7241c23a6"
  end

  def install
    (buildpath/"openssl").install resource("insecure-openssl")

    # prevent sslscan from fetching the tip of the openssl fork
    # at https://github.com/PeterMosmans/openssl
    inreplace "Makefile", "openssl/Makefile: .openssl.is.fresh",
                          "openssl/Makefile:"

    ENV.deparallelize do
      system "make", "static"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
