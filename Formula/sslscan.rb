class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.13-rbsec.tar.gz"
  version "1.11.13"
  sha256 "8a09c4cd1400af2eeeec8436a2f645ed0aae5576f4de045a09ea9ff099f56f4a"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "788f9752e795f4ff95e1251a243a5829a6f9b40facbdca40e4819de5f9d7dc4c" => :catalina
    sha256 "8a8826da03dbbaa9ee89c8e6b95496c178f5a93d86468402fb6e432ebc7f2c68" => :mojave
    sha256 "e0735e75b58b7cb0ef72cc79089df545e0140e52bc206c1791ab979192251d22" => :high_sierra
    sha256 "4b00ee57ccf8dfbc890bbc7ca978dd4f310e7f73dfc022c78c33b69b9b3449dc" => :sierra
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
