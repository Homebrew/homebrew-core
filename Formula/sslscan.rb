class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.11-rbsec.tar.gz"
  version "1.11.11"
  sha256 "93fbe1570073dfb2898a546759836ea4df5054e3a8f6d2e3da468eddac8b1764"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b45535639610fd506cad8ff708810d2ef033fb2eb23a887705191a34c8505bc9" => :high_sierra
    sha256 "7b608acf33d2cbb2e5dd66f99a5c2ca731304ad01f3f5e55e0daadcf2efe69f9" => :sierra
    sha256 "25b58dc0d59e2da5c85fefc128965e882a10b659e63a1f719d89eca5f6fdb25c" => :el_capitan
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
