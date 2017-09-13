class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.10-rbsec.tar.gz"
  version "1.11.10"
  sha256 "fbb26fdbf2cf5b2f3f8c88782721b7875f206552cf83201981411e0af9521204"
  revision 1
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "760493b1794996041d47caf811b09cd3724b6ca7b7918594b7eb308d8bcfa793" => :sierra
    sha256 "29e4cdd913a4b684fabd70f58d4be444e1a38b7aefc8d15e00e02b1c286a41d2" => :el_capitan
    sha256 "4ac19a3ddd29aa89fbc69758399c4a5c18b63ca01795643ec35c354a7454b2f0" => :yosemite
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
