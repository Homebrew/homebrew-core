class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.10-rbsec.tar.gz"
  version "1.11.10"
  sha256 "fbb26fdbf2cf5b2f3f8c88782721b7875f206552cf83201981411e0af9521204"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "74866c6955b5603ba494ffaa66c028e690e1cdaad792def87eccf13367c5c043" => :sierra
    sha256 "3294b6c4956bc565af8b714c5e633f5e5b7a05dd4d19a07d8ddaf1f90dcf2d44" => :el_capitan
    sha256 "0537cb08b5d621601741a9b92d9a0bcec978242b3ca5830711a49a3ebf99036b" => :yosemite
  end

  depends_on "openssl"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
