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

  depends_on "openssl"

  def install
    system "make"
    # This regression was fixed upstream, but not in this release.
    # https://github.com/rbsec/sslscan/commit/6e89c0597ebc779ac82
    # Remove the below line on next stable release.
    mkdir_p [bin, man1]
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
