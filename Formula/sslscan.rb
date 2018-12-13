class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.12-rbsec.tar.gz"
  version "1.11.12"
  sha256 "f453a6606ff115aa2b9485fbb20856d63f9110752e42069a02277d5e63a5ce0e"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3275b8b444a9da183e2145ec02d4ae0fb1d0da084323fa80bd04808310cde002" => :mojave
    sha256 "596285eb6b6ffaa57d41f00d03d9d1447e2e559d33f8db8c66eefc665e5d7e98" => :high_sierra
    sha256 "c71304b18d68a5f61a1d484a2e0588468b992a0e651ab7393bac7a5cc2b2bbb1" => :sierra
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
