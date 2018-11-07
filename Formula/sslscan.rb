class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.12-rbsec.tar.gz"
  version "1.11.12"
  sha256 "f453a6606ff115aa2b9485fbb20856d63f9110752e42069a02277d5e63a5ce0e"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7273ca4f3108b1765d168d1581d0bc026c9b586163da697bcf54cbddfb52abf4" => :mojave
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
