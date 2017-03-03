class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.8-rbsec.tar.gz"
  version "1.11.8"
  sha256 "1449f8bb45d323b322cb070a74d8dcc57b43ca2dba0560e7a16151efc8b3d911"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "04e602109f1066a74f01bb71ba9fcfd354b3508a0dafbc1c4951f30d276aade1" => :sierra
    sha256 "30a096d3b1458298d1015a61baac9ddc7aab548a0855b47becbf3add224b256a" => :el_capitan
    sha256 "b69483d7db7813ad144004b0f8c4f6848e6f8f59d305c2d8fd4499ec355247de" => :yosemite
  end

  option "with-static-openssl", "Statically link OpenSSL to enable weak ciphers"

  if build.without? "static-openssl"
    depends_on "openssl"
  end

  def install
    if build.with? "static-openssl"
      system "make", "static"
    else
      system "make"
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    if build.with? "static-openssl"
      version = pipe_output([bin/"sslscan", "--version"], nil, 0)
      assert_match(/-static$/, version.lines.first)
    end
    system "#{bin}/sslscan", "google.com"
  end
end
